# Yogit-iOS
## 📱 Global Gathering by Locally Based Interest
iOS 앱 클라이언트 부분은 혼자 개발하다보니, 커밋을 기능 단위로 하는 것을 간과하고 덩어리 단위로 하여 커밋 수가 적습니다...
#### App store (iPhone) <https://apps.apple.com/app/yogit-%EC%9A%94%EA%B9%83/id6447361140>
<img width="1406" alt="Portfolio_Demo" src="https://github.com/devjohnpark/DataStructure/assets/109328441/fcbfbe6d-dc6c-40e5-9292-534a28647347">

* Subject | Global gathering app by local based interests
* Subtitle | O2O gathering with locals & foreigners
* Target (developed in consideration of global service launch)
	* People from various countries nearby and people who want various activities and experiences
	*  Who wants to actually improve their foreign language skills
* Support | iOS 16.0 V ~ / DarkMode
* Dark mode | Support
* iOS Tech
	* Language | Swift
	* Framework | UIKit, Mapkit, Core Location
	* DataBase | Keychain, Realm, UserDefaults
	* Autolayout | Snapkit, CodeBasedUI
	* Architecture | MVC
	* Asynchronous | GCD, Async await
	* Image caching | Kingfisher
	* Network (REST API) | Alamofire, URLSession
	* Login API | Sign in with Apple
	* APN
	* Localize
         - All languages | Address, Region, Date&Time, Nationality list selection, Language list selection
         - Korean, English | APN, Service phrase, User permission phrase

<br/>

#### Architecture

<img src="https://github.com/devjohnpark/DataStructure/assets/109328441/7ea1c64e-06f9-491f-8ae5-2b20296cf2d8" width="700" height="770"/>

<br/>

### App key feature (1.5.7 Version)
---
#### Member management

	Sign Up (with Apple login)
	Log In
	Log out
	Delete account
	Customer service center

|<img src="https://github.com/devjohnpark/DataStructure/assets/109328441/debd7cae-d052-42fa-837a-ccd89c76a240" width="200" height="430"/>|<img src="https://github.com/devjohnpark/DataStructure/assets/109328441/7660b9af-36f0-43ec-a9e3-55dea49a95a1" width="200" height="430"/>|<img src="https://github.com/devjohnpark/DataStructure/assets/109328441/144f9edf-8e9b-4825-974e-0cd7fd23edc0" width="200" height="430"/>|
|:---:|:---:|:---:|
|Sign Up & Create Profile|Log In/Out|Delete Account|


<br/>

#### Read gathering list

	Read gathering list by (category, city name)
	Refresh gathering boards 
	Infinte scroll (paging)

|<img src="https://user-images.githubusercontent.com/109328441/235421445-dca4e839-1643-425f-9f88-30d97816661b.gif" width="200" height="430"/>|<img src="https://user-images.githubusercontent.com/109328441/235421686-a30d810a-83db-4ed4-a2e2-e3382cfff1b2.gif" width="200" height="430"/>|
|:---:|:---:|
|Read gathering list|Infinte Scroll|

<br/>

#### Gathering post

	Gathering post CRUD
	Copy gathering address
	Open gathering location with apple/google/kakao app or web map
	Join the gathering 
	Cancel joined gathering 
	Report post
	Get user's profile

|<img src="https://github.com/devjohnpark/DataStructure/assets/109328441/e5044572-2b2a-4729-a271-a9a3b2cb7f53" width="200" height="430"/>|<img src="https://github.com/devjohnpark/DataStructure/assets/109328441/d1559831-3a4b-45e4-bb26-2703c8bc9e21" width="200" height="430"/>|<img src="https://user-images.githubusercontent.com/109328441/235424164-828ddba2-3e2f-49b9-a5cb-fcf5cdb93935.gif" width="200" height="430"/>|<img src="https://user-images.githubusercontent.com/109328441/235594306-a6dd6622-af9d-4692-8a6b-58d78880521d.gif" width="200" height="430"/>|
|:---:|:---:|:---:|:---:|
|Create post|Read post(join/cancel)|Update post|Delete post|

<br/>

#### Clipboard (Implementation of gathering chat room with HTTP communication)

	Create clipboard
	Read clipboard
	Paging (infinte scroll up down)
	Report clipboard

|<img src="https://github.com/devjohnpark/DataStructure/assets/109328441/27a2a4fb-6b47-41cb-ba27-d76499dadab9" width="200" height="430"/>|<img src="https://github.com/devjohnpark/DataStructure/assets/109328441/f73d3a12-fb51-4f9e-8fbf-809a219f8d05" width="200" height="430"/>|<img src="https://github.com/devjohnpark/DataStructure/assets/109328441/71b493ba-42fc-4a72-8afa-2d56f3a97b56" width="200" height="430"/>|<img src="https://user-images.githubusercontent.com/109328441/235577132-49916ae0-b5e4-431c-b32c-b4e17c101089.gif" width="200" height="430"/>|
|:---:|:---:|:---:|:---:|
|Clipboard|Clipboard up paging|Clipboard down paging|Report Clipboard|

<br/>

#### Block/Report user

	Block user
	Report user
	
|<img src="https://github.com/devjohnpark/DataStructure/assets/109328441/015459c6-0107-4fc8-8862-fb266972b4ad" width="200" height="430"/>|<img src="https://github.com/devjohnpark/DataStructure/assets/109328441/cff4789c-7223-4f53-a53b-95500b48e922" width="200" height="430"/>|
|:---:|:---:|
|Block user|Report user|

<br/>

#### User's gathering post

	Joined gathering
	Opened gathering

|<img src="https://user-images.githubusercontent.com/109328441/235426762-28112f8f-c239-4302-b1a1-1086a5b110fa.gif" width="200" height="430"/>|
|:---:|
|Read joined/Opend post|

<br/>

#### Profile

	Create (with sign up)
	Read 
	Update
	Delete (with delete account)

|<img src="https://github.com/devjohnpark/DataStructure/assets/109328441/f82aa02b-e76e-4fb4-9bf0-6121e89fba23" width="200" height="430"/>|<img src="https://github.com/devjohnpark/DataStructure/assets/109328441/0f1d29b0-355a-413b-a87e-95140b9c6921" width="200" height="430"/>|
|:---:|:---:|
|Read Profile|Update Profile|

<br/>

#### Push notifications

	Clipboard notifications
	Activity notifications

|<img src="https://user-images.githubusercontent.com/109328441/235421939-942585f4-fda7-4efe-a2a9-65986dff9814.gif" width="200" height="430"/>|
|:---:|
|Clipboard/Activity notifications|








