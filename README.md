# Matcha Scripting
## 用你習慣的方式Shell Scripting

### 這個工具能做什麼?    
 - 用模組化的方式撰寫 Shell Script (bash)
 - 自動化建置 iOS Xcode Project
 - 使用 delegate 的方式客製化 Xcode Project Build Phase
 - 與 Jenkins 整合使用
  
### 一些工具的參數及準備工作 

1. 預先設置環境
fastlane sigh :安裝 Fastlane

$sudo gem install fastlane -NV
#[Reference] https://github.com/fastlane/fastlane


憑證遷移  	   :確認Certificate是否位於login的項目中，如不是，請先將需要的憑證從 KeyChain "System(系統)" 移至 "login(登入)"


2. 基本操作方式
- CI      : matcha build -ci
- 建構環境 : source matcha basic 
- import moudle : @import Builder
  
### 自訂參數 ( `**` is the default value. )
```
-------------------------[ Required ]--------------------------------
-s		PROJ_SCHEME			# (required) no default.  it's required, if project is built by xcworkspace.
-delegate 	DELEGATE                    	# (required) no default, should implement functions of delegate.

-------------------------[ Optional ]--------------------------------
-v		VERSION				# **by project, e.g. -v 1.0
-bv		BUILD_VERSION			# **by project
-ein		EXPORT_IPA_NAME			# **same as Archive_Name. e.g. -ein "beta.ipa"
-conf		BUILD_CONFIGURATION		# default from scheme in xcode project, e.g. Debug, Release, it's case sensitive.
-eo		EXPORT_OPTION			# **app-store, enterprise, ad-hoc, development
-u		PROVISIONING_UUID           	# **Default from PROVISIONING_PROFILE_NAME
-ep		EXPORT_FOLDER			# **Default Export path "./export/"
-lp		LOG_FOLDER			# **Default Log path "./log"
-p		PROVISIONING_PROFILE_NAME	# no default. The provision profile name to fetch with.
-i    		APP_ID				# default will set by xcode project build settings.
-path		APP_PATH			# assign to the exist project path, it won't build project by cloning from git.
-tn   		TEAM_NAME			# (required) no default. e.g. Hiiir, Inc. Taiwan Branch.
-passwd		PASSWD				# the password of this macOS account.

-------------------------[ Fastlane ]--------------------------------
-ndp		NEED_DOWNLOAD_PROVISION_PROFILE
-aid		APPLE_ID			# without default, it used by fastlane downaloding PROVISIONING_PROFILE, if you wanna automatic execute, you have to set up -apwd.

-apwd		APPLE_ID_PASSWORD		# For fastlane `sigh` to download PROVISIONING_PROFILE , and don't worry , it won't be saved!

-------------------------[ Git ]--------------------------------
-b		GIT_BRANCH_APP			# **master
-app_tag	GIT_TAG_APP			# no default

-------------------------[ Mode switch ]--------------------------------
-ci		BUILD_CI			# don't give a value, it will switch to ci mode.

-------------------------[ Not important anymore ]--------------------------------
-ti		TEAM_ID				# default from provision profile.
-si		SIGNING_IDENTITY		# **iPhone Distribution: [TEAM_NAME].
```

### delegate protocol 

- Functions 定義
  * (optional) builder_will_launch(launch_parameter) : Builder 將進行前置作業/清除舊資料前呼叫。
  * (optional) builder_did_launch()                  : Builder 完成進行前置作業，即將進行Build Script動作。
  * (optional) builder_will_exec(action)             : 即將進行特定動作前呼叫，所進行的動作將透過 action/$1 提供
  * (optional) builder_did_exec(action)              : 完成特定動作時呼叫，所進行的動作將透過 action/$1 提供
  * (optional) builder_did_end()                     : Builder 完成所有動作，並清除資料後進行

- Action 定義
  * builder     : Builder Phase.        { will: 全部 Phase 進行前 | did: 全部 Phase 完成後 }
  * build_app   : Build & Archive App.  { will: build app 前 | did: build app 完成後 }
  * git         : Git clone app.        { will: clone git app 前 | did: clone git app 完成後 }
  * export_ipa  : Export to ipa file.   { will: export 進行前 | did: export 完成後 }
 
