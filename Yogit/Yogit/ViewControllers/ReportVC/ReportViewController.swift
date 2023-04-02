//
//  ReportViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/02/12.
//

import UIKit
import SnapKit
import ProgressHUD

enum ReportType: Int, CaseIterable {
    case obscenity = 0 // 음란
    case falseProfile // 허위 프로필
    case racistRemarks // 인종 차별 발언
    case abusiveLanguageAndSlander // 욕설 및 비방
    case others
    
    func title() -> String {
        switch self {
        case .obscenity: return "OBSCENITY".localized()
        case .falseProfile: return "FALSE_PROFILE".localized()
        case .racistRemarks: return "RACIST_REMARKS".localized()
        case .abusiveLanguageAndSlander: return "ABUSIVE_LANGUAGE_AND_SLANDE".localized()
        case .others: return "OTHERS".localized()
        }
    }
}

enum ReportKind: Int, CaseIterable {
    case clipboardReport = 0 // 클립보드 신고
    case boardReport // 보드 신고
    case userReport // 유저 프로필 신고
}

class ReportViewController: UIViewController {
    var reportedUserId: Int64? // 필수
    var reportedClipBoardId: Int64? // 클립보드
    var reportedBoardId: Int64? // 모임 보도
    var reportKind: ReportKind? // 신고 종류
    var reportContentString: String? // text content
    var reportTypeIdx: Int?
    
    private var selectedButton: UIButton? {
        didSet {
            selectedButton?.tintColor = .systemRed
        }
    }
    
    private let reportContentTextView = MyTextView()
    
    private let textMax = 300
    private let placeholder = "REPORT_CONTENT_PLACEHOLDER".localized()
    
    private let lineView1: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
       return view
    }()
    
    private let lineView2: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
       return view
    }()

    private let precautionsNoteLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemRed //.white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.sizeToFit()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.text = "REPORT_NOTE_TITLE".localized()
        return label
    }()
    
    private let precautionsContentLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemRed
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.sizeToFit()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.text = "REPORT_NOTE_SUBTITLE".localized()
        return label
    }()
    
    private let reportTypeContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let reportTypeLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.sizeToFit()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.text = "REPORT_TYPE_KIND_TITLE".localized()
        return label
    }()
    
    private let reportReasonLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.sizeToFit()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.text = "REPORT_CONTENT_TITLE".localized()
        return label
    }()
    
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(leftButtonPressed(_:)))
        button.tintColor = .label
        return button
    }()
    
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "DONE".localized(), style: .plain, target: self, action: #selector(rightButtonPressed(_:)))
        button.tintColor = .label
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponent()
        configureReportTypeView()
        configureNavItem()
        configureTextView()
    }
    
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            precautionsNoteLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            precautionsNoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            precautionsNoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            precautionsContentLabel.topAnchor.constraint(equalTo: precautionsNoteLabel.bottomAnchor, constant: 10),
            precautionsContentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            precautionsContentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            lineView1.topAnchor.constraint(equalTo: precautionsContentLabel.bottomAnchor, constant: 30),
            lineView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            lineView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            lineView1.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            reportTypeLabel.topAnchor.constraint(equalTo: lineView1.bottomAnchor, constant: 20),
            reportTypeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reportTypeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            reportTypeContentView.topAnchor.constraint(equalTo: reportTypeLabel.bottomAnchor, constant: 0),
            reportTypeContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reportTypeContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            reportTypeContentView.heightAnchor.constraint(equalToConstant: CGFloat(50*ReportType.allCases.count))
        ])

        NSLayoutConstraint.activate([
            lineView2.topAnchor.constraint(equalTo: reportTypeContentView.bottomAnchor, constant: 0),
            lineView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            lineView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            lineView2.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            reportReasonLabel.topAnchor.constraint(equalTo: lineView2.bottomAnchor, constant: 20),
            reportReasonLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reportReasonLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            reportContentTextView.topAnchor.constraint(equalTo: reportReasonLabel.bottomAnchor, constant: 0),
            reportContentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reportContentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            reportContentTextView.heightAnchor.constraint(equalToConstant: 150),
            reportContentTextView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
        view.addSubview(precautionsNoteLabel)
        view.addSubview(precautionsContentLabel)
        view.addSubview(lineView1)
        view.addSubview(reportTypeLabel)
        view.addSubview(reportTypeContentView)
        view.addSubview(lineView2)
        view.addSubview(reportReasonLabel)
        view.addSubview(reportContentTextView)
    }
    
    private func configureNavItem() {
        self.navigationItem.title = "REPORT".localized()
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    private func configureTextView() {
        if reportKind == .clipboardReport {
            reportReasonLabel.isHidden = true
            reportContentTextView.isHidden = true
        } else {
            reportContentTextView.myTextView.delegate = self
            reportContentTextView.textCountLabel.text = "\(reportContentTextView.myTextView.text.count) / \(textMax)"
            if reportContentTextView.myTextView.text == nil || reportContentTextView.myTextView.text == "" {
                reportContentTextView.myTextView.text = placeholder
            } else {
                reportContentTextView.myTextView.textColor = .label
            }
        }
    }
    
    @objc func leftButtonPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func rightButtonPressed(_ sender: UIButton) {
        // 클립보드일경우 텍스트뷰 없음
        if (reportContentTextView.myTextView.text != placeholder && reportContentTextView.myTextView.text != "") || reportKind == .clipboardReport {
            print("첫")
            guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String else { return }
            guard let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
            guard let content = reportContentString else { return }
            guard let reportType = reportTypeIdx else { return }
            guard let reportedUserId = reportedUserId else { return }
            let refreshToken = userItem.refresh_token
            let reportingUserId = userItem.userId
            let reportRouter: ReportRouter
            switch reportKind {
            case .boardReport:
                guard let reportedBoardId = reportedBoardId else { return }
                reportRouter = .reportBoard(parameters: ReportBoardReq(content: content, refreshToken: refreshToken, reportType: reportType, reportedBoardId: reportedBoardId, reportedUserId: reportedUserId, reportingUserId: reportingUserId))
            case .clipboardReport:
                guard let reportedClipBoardId = reportedClipBoardId else { return }
                reportRouter = .reportClipBoard(parameters: ReportClipBoardReq(content: content, refreshToken: refreshToken, reportType: reportType, reportedClipBoardId: reportedClipBoardId, reportedUserId: reportedUserId, reportingUserId: reportingUserId))
            case .userReport:
                reportRouter = .reportUser(parameters: ReportUserReq(content: content, refreshToken: refreshToken, reportType: reportType, reportedUserId: reportedUserId, reportingUserId: reportingUserId))
            case .none: return
            }
            AlamofireManager.shared.session
                .request(reportRouter)
                .validate(statusCode: 200..<501)
                .responseDecodable(of: APIResponse<[String:Int64]>.self) { response in
                switch response.result {
                case .success:
                    if let value = response.value, value.httpCode == 201 || value.httpCode == 200 {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true) // 프로필 화면
                            ProgressHUD.dismiss()
                        }
                    }
                case let .failure(error):
                    print(error)
                    DispatchQueue.main.async {
                        ProgressHUD.dismiss()
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "", message: "REPORT_CONTENT_ALERT".localized(), preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        }
    }
    
    private func configureReportTypeView() {
        let reportCnt = ReportType.allCases.count
        for i in 0..<reportCnt {
            let stackView = UIStackView()
            let label = UILabel()
            guard let title = ReportType(rawValue: i)?.title() else { return }
            setupLabel(stackView: stackView, label: label, title: title)
            let button = UIButton()
            button.isUserInteractionEnabled = false
            setupButton(stackView: stackView, button: button)
            stackView.tag = i
            setupStackView(stackView: stackView, label: label, button: button, y: CGFloat(44*i))
            if i != reportCnt-1 {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.backgroundColor = .systemGray6
                reportTypeContentView.addSubview(view)
                NSLayoutConstraint.activate([
                    view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0),
                    view.leadingAnchor.constraint(equalTo: reportTypeContentView.leadingAnchor, constant: 0),
                    view.trailingAnchor.constraint(equalTo: reportTypeContentView.trailingAnchor, constant: 0),
                    view.heightAnchor.constraint(equalToConstant: 0.5)
                ])
            }
        }
    }
    
    private func setupLabel(stackView: UIStackView, label: UILabel, title: String) {
        stackView.addArrangedSubview(label)
        label.text = title
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
    }
    
    private func setupButton(stackView: UIStackView, button: UIButton) {
        stackView.addArrangedSubview(button)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let imageNormal = UIImage(systemName: "checkmark", withConfiguration: imageConfig)
        button.setImage(imageNormal, for: .normal)
        button.tintColor = .placeholderText
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func setupStackView(stackView: UIStackView, label: UILabel, button: UIButton, y: CGFloat) {
        reportTypeContentView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.backgroundColor = .systemBackground
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.reportStackViewTapped(_:))))
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: reportTypeContentView.topAnchor, constant: y),
            stackView.leadingAnchor.constraint(equalTo: reportTypeContentView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: reportTypeContentView.trailingAnchor, constant: 0),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func reportStackViewTapped(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
            guard let view = sender.view,
                  let stackView = view as? UIStackView,
                  let button = stackView.arrangedSubviews[1] as? UIButton
            else {
                return
            }
            reportTypeIdx = view.tag
            selectedButton?.tintColor = .placeholderText
            selectedButton = button
        })
    }
}


extension ReportViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // make sure the result is under 16 characters
        return updatedText.count <= textMax
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholder
            textView.textColor = .placeholderText
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        reportContentTextView.textCountLabel.text = "\(textView.text.count) / \(textMax)"
        if textView.text != placeholder {
            reportContentTextView.textCountLabel.textColor = .label
        } else {
            reportContentTextView.textCountLabel.textColor = .placeholderText
        }
        reportContentString = textView.text
    }
}
