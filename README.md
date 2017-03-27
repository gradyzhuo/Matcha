![](logo1.jpg)

# 用模組的方式Shell Scripting

## 這個工具能做什麼?    
* 用模組化的方式撰寫 Shell Script (bash)
* 自動化建置 iOS Xcode Project
* 使用 delegate 的方式客製化 Xcode Project Build Phase
* 與 Jenkins 整合使用

## 安裝

```bash
# 切換至 Clone 的 Match 路徑
$ cd [CLONED_MATCHA_FOLDER]

# 執行 install.sh 啟動安裝程序
$ ./install.sh
```

#### 看到以下的畫面表示 Matcha 安裝成功

```bash
[17-03-27 19:11:05] Preparing Matcha 1.0 ...
[17-03-27 19:11:05] Draining ...
[17-03-27 19:11:06] Bubbling Matcha ...
[17-03-27 19:11:06] Installing modules...
[17-03-27 19:11:07] Cleaning...

Bubbling succeed to `/Users/grady_zhuo/.Matcha`!🍵 🍵 🍵
You can start by `matcha help`.
``` 

## 使用方式

### 基本操作指令

```bash
# 在現在的 shell process 引用 Matcha
$ source matcha

# 看到以下畫面表示 Matcha 載入完成

＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃
＃　　　　　　　　　　　　　　　　　　　　　　　　　　　　＃
＃　　　　　　　～～　Ｗｅｌｃｏｍｅ　～～　　　　　　　　＃
＃　　　　　　Ｍａｔｃｈａ　Ｓｃｒｉｐｔｉｎｇ　　　　　　＃
＃　　　　　　　Ｖｅｒｓｉｏｎ　　１．０　　　　　　　　　＃
＃　　　　　　　　　　　　　　　　　　　　　　　　　　　　＃
＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃

```

### 使用模組
* 載入模組的路徑：
  * [Matcha Path]/modules/[MODULE_NAME].mm
* 預載的模組：
  * Prints
  * Files
* 現行可用的內建模組：
  * Prints
  * Files
  * Builder
  * Git
  * MailSupport
  * XC

```bash
# 從內建的模組引入 Module
$ @import [MODULE_NAME]
# 或是從其他路徑引入 Module，請引入到包含 @.imports 的該層資料夾層級即可。
$ @import [Matcha Path]

# 在 Terminal 看到類似以下畫面表示 Module 載入完成
$ @import XC
[17-03-26 01:10:24] >> Module [XC] import succeed.

```

### 安裝模組
透過模組的製作，您也可以將你自已撰寫的模組安裝到Matcha中，模組預設會安裝至 `[HOME]/.Matcha/usr/modules` 並會建立捷徑至 `[HOME]/.Matcha/modules/[MODULE_NAME].mm`

```bash
# 請指定到包含 @.imports 的該層資料夾層級即可
# 預設的模組名稱會是資料夾的名字
$ matcha module install [MODULE_PATH]

#你也可以指定模組的名稱，請在路徑後方打入自訂模組的名稱即可
$ matcha module install [MODULE_PATH]  [MODULE_NAME]
```

### Matcha Commands

```bash
# 你可以在執行 matcha 後面攜帶 Command 及其參數，以執行所需的動作。
$ matcha [COMMAND_NAME] [PARAMETERS]

#或使用 @exec 以執行 command.
$ source matcha
@exec [COMMAND_NAME] [PARAMETERS]
# 注意，@exec 並不支持在終端機(terminal) 直接使用，但您可在撰寫其他腳本做為內文使用。
```

--
待更新…

#### 表1: 可用的參數

##### archive
```
-------------------------[ Required ]--------------------------------
-s		PROJ_SCHEME			# (required) no default.  it's required, if project is built by xcworkspace.
-delegate 	DELEGATE                    	# (required) no default, should implement functions of delegate.

-------------------------[ Optional ]--------------------------------
-v		APP_VERSION				# **by project, e.g. -v 1.0
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

-------------------------[ Not important anymore ]--------------------------------
-ti		TEAM_ID				# default from provision profile.
-si		SIGNING_IDENTITY		# **iPhone Distribution: [TEAM_NAME].
```


### delegate protocol

* Functions 定義
	* (optional) builder_will_launch(launch_parameter) : Builder 將進行前置作業/清除舊資料前呼叫。
	* (optional) builder_did_launch()                  : Builder 完成進行前置作業，即將進行Build Script動作。
	* (optional) builder_will_exec(action)             : 即將進行特定動作前呼叫，所進行的動作將透過 action/$1 提供
	* (optional) builder_did_exec(action)              : 完成特定動作時呼叫，所進行的動作將透過 action/$1 提供
	* (optional) builder_did_end()                     : Builder 完成所有動作，並清除資料後進行

* Action 定義
	* builder     : Builder Phase.        { will: 全部 Phase 進行前 | did: 全部 Phase 完成後 }
	* build_app   : Build & Archive App.  { will: build app 前 | did: build app 完成後 }
	* git         : Git clone app.        { will: clone git app 前 | did: clone git app 完成後 }
	* export_ipa  : Export to ipa file.   { will: export 進行前 | did: export 完成後 }
