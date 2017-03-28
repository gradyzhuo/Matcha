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
