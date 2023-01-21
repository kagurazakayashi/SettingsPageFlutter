# SettingsPageFlutter

从 iOS 的 plist 设置配置文件生成一个选项设置页

**没有做完，请勿使用。**

## 支持平台
|                 |               |               |
| --------------- | ------------- | ------------- |
| &check; Android | &check; iOS   | &cross; Web   |
| &check; Windows | &cross; macOS | &cross; Linux |

## 使用方法

详情参考示例： `example/lib/select_page.dart` 。

1. 在 `pubspec.yaml` 的 `dependencies:` 中添加本库 `settingspageflutter` 。并使用 `flutter pub get` 下载所需文件。
2. 前往你的配置页面（示例程序中为 `select_page.dart` (Android 风格) 和 `cupertino_select_page` (iOS 风格) ），这个配置页面也将用来显示所有子配置页。以下以 `select_page.dart` 为例。
3. 在头部引入相关类
    1. 在头部引入 plist 加载器 `import 'package:settingspageflutter/settingspageloader.dart';` ，用于载入 plist 文件为所需数据格式。
    2. 在头部引入分组控件 `import "package:settingspageflutter/widget/we_group_item.dart";` ，用于对 Group 的处理。
    3. 在头部引入大小和缩放计算功能 `import "package:settingspageflutter/widget/we_size.dart";` ，用于根据窗口/屏幕大小确定尺寸。
4. 在 `void initState()` 中加载你需要的 plist 文件：
    1. 初始化一个 `SettingsPageLoader` 对象，可以在参数中可选提供一个存放 plist 文件的根目录，默认是 `Settings.bundle/` 。例如 `SettingsPageLoader loader = SettingsPageLoader("config.bundle)` 。
    2. 执行 `SettingsPageLoader.loadPlistFile` ，并指定一个文件名（不是路径，路径基于上面指定的根目录，不包括扩展名），默认为 `Root` (.plist) 。例如 `loader.loadPlistFile(plistFileName: "Root");` 。
    3. 为上个方法添加 `.then((value) {...});` ，决定读取成功之后应该做什么。其中 `SettingsPageData value` 中包含：
        1. `String value.title`: 标题，通常显示在 AppBar 上面。
        2. `String value.stringsTable`: 自定义文件 id 。
        3. `List<Map<String, dynamic>> value.preferenceSpecifiers`: 所有当前 plist 文件所指定的选项都在这里面。
    4. 为上个方法添加 `.catchError((error) {...});` ，其中 `error` 通常为 String ，如果解析失败，将会在这里告诉你原因。
    5. 将上述获得的 `List<Map<String, dynamic>> value.preferenceSpecifiers` 存到一个属性内，以便后续使用，例如 `List _settingData = []; ... _settingData = value.preferenceSpecifiers;` 。
5. 创建 UI 文件，准备填充数据。前往该文件的 `Widget build(BuildContext context)` 方法，添加内容。一个通常的例子：
    1. 最顶端需要一个 `AppBar` ，包含一个 `Text` ，用于显示上面的当前页面标题 `value.title` 。
    2. 在主要内容处，先判断 `_settingData.isNotEmpty` ，以确定尚未加载 plist 完成时需要提供的 UI 。
    3. 使用 `ListView.builder` 创建一个 `ListView` ，这个主要内容列表。该列表的 `itemCount` 为 `_settingData.length` ，并在 `itemBuilder: (context, i) {}` 中进行主要内容的构建：
    4. 该方法提供了遍历序号 `i` ，使用 `_settingData[i]` 来取出当前项目，例如 `Map<String, dynamic> nowItem = _settingData[i];` 。
6. 创建 `WeGroupItem` 对象，
    1. 在 `isDark` 中提供一个 bool 值，可以打开暗色模式。
    2. 在 `decoration` 中提供一个 `BoxDecoration` 作为样式。
    3. 在 `data` 里指定解析后的 plist 数据(`value.preferenceSpecifiers`) 。
    4. 在 `onClick: (childs, file, type) {}` 中确定用户点击具有下一页的内容后要执行的内容（不包括多项选择 `PSMultiValueSpecifier` ）。
        1. `List<Map<String, dynamic>>? childs`: 可加载的子项。
        2. `String? file`: 可加载的路径。通常 `childs` 和 `file` 只有其中一个有内容，如果都没有，视为根菜单。
        3. `String type`: 用户操作的控件类型（ plist 中定义的名称）。可以根据用户点选的类型来确定具体的通用行为。
        4. 此时需要使用 `Navigator.push` 进行换页。
            1. 将 `MaterialPageRoute(builder: (context))` 指定为本页面自身以重复利用。
            2. 将用户选择的下一个文件传递给下个页面，将 `onClick` 的 `file` 传递给新页。
    5. 在 `onChanged: (key, value, isTip) {}` 中确定用户调整某项内容之后应该做什么。
        1. `key` 为数据中的 key
        2. `value` 为数据中的值
        3. `isTip` 用于判断是否需要提示，当前只有`PSTextFieldSpecifier`类型的项才会有提示（因为开关等控件时所见即得）
        5. 在此处添加更新数据的代码。
        6. 可以根据 `isTip` 来向用户提供一个修改成功的提示信息。

## Settings.bundle 和 MaterialApp 属性对照

实现方式：

- `-` 表示仅在事件回调中体现
- `+` 会进行额外的实现
- `x` 表示不支持
- `*` 本插件特有项, Settings.bundle 中没有

### 键盘类型 (keyboardType)

| Settings.bundle         | MaterialApp   | 功能     |
| ----------------------- | ------------- | -------- |
| keyboardType            | TextInputType | 功能类名 |
| Alphabet                | text          | 文本键盘 |
| Numbers and Punctuation | number        | 数字键盘 |
| Number Pad              | phone         | 电话键盘 |
| URL                     | url           | 网址键盘 |
| Email Address           | emailAddress  | 邮件键盘 |
| Multi Line \*           | multiline     | 多行文本 |

### 分组 (Group)

| Settings.bundle | 功能         |
| --------------- | ------------ |
| Group           | 分组         |
| Type            | Group        |
| Title           | 分组显示标题 |
| FooterText      | 分组底部文本 |

### 多项选择框 (Multi Value)

key: `PSMultiValueSpecifier`

| Settings.bundle | Default | 功能     | 类型   |
| --------------- | ------- | -------- | ------ |
| Key             | -       | 标识符   | String |
| Title           | -       | 标题     | String |
| Childs          | -       | 标题集合 | List   |

### 多项选择框 (Multi Value) - 子项 (Childs)

| Settings.bundle | Default | 功能   | 类型   |
| --------------- | ------- | ------ | ------ |
| Title           | -       | 标识符 | String |
| Val             | -       | 标题   | String |

 <!--            | Default Value | 默认值 | -->

### 滑动条 (Slider)

key: `PSSliderSpecifier`

| Settings.bundle  | MaterialApp   | Default                 | 功能       | 类型   |
| ---------------- | ------------- | ----------------------- | ---------- | ------ |
| Key              | -             | -                       | 标识符     | String |
| Title \*         | label         | ""                      | 标题       | String |
| DefaultValue     | value         | 0                       | 默认值     | double |
| MinimumValue     | min           | 0                       | 最小值     | double |
| MaximumValue     | max           | 100                     | 最大值     | double |
| accuracy         | -             | 0                       | 精度       | int    |
| NumberOfSteps \* | divisions     | 1                       | 步进大小   | int    |
| activeColor      | activeColor   | 0xFF2196F3(Colors.blue) | 活动颜色   | int    |
| inactiveColor    | inactiveColor | 0xFF9E9E9E(Colors.grey) | 非活动颜色 | int    |

<!-- | Key               | -           |         | 标识符      |
| Max Value Image Filename | x           |         | 最大端图片  |
| Min Value Image Filename | x           |         | 最小端图片  | -->

### 文字输入框 (TextField)

key: `PSTextFieldSpecifier`

| Settings.bundle         | MaterialApp        | Default | 功能               | 类型     |
| ----------------------- | ------------------ | ------- | ------------------ | -------- |
| Key                     | -                  | -       | 标识符             | String   |
| Title                   | labelText          | ""      | 标题               | String   |
| DefaultValue            | ""                 | ""      | 默认值             | String   |
| HintText                | hintText           | ""      | 提示文本           | String   |
| AutocorrectionStyle     | autocorrect        | false   | 自动纠正拼写       | bool     |
| AutocapitalizationStyle | TextCapitalization | none    | 自动大写(暂不支持) | String   |
| TextFieldIsSecure       | obscureText        | false   | 是否密文显示       | bool     |
| KeyboardType            | keyboardType       | text    | 键盘样式           | String   |
| ReturnKeyType           | textInputAction    | done    | 键盘回车键样式     | String   |
| MaxLines                | maxLines           | 1       | 最大行数           | int      |
| MaxLength               | maxLength          | null    | 最大长度           | int/null |
| AutoFocus               | autofocus          | false   | 是否自动获取焦点   | bool     |

### 标题框 (Title)

| Settings.bundle | MaterialApp | 功能        |
| --------------- | ----------- | ----------- |
| Title           | Text        | Widget 名称 |
| Key             | -           | 标识符      |
| Title           | Text        | 标题文本    |
| Default Value   | x           | 默认值      |

### 开关 (Toggle Switch)

key: `PSToggleSwitchSpecifier`

| Settings.bundle | MaterialApp | Default | 功能     | 类型   |
| --------------- | ----------- | ------- | -------- | ------ |
| Key             | -           | -       | 标识符   | String |
| Title           | Text        | -       | 标题文本 | String |
| DefaultValue    | value       | -       | 默认值   | bool   |

## LICENSE

Copyright (c) 2023 KagurazakaYashi SettingsPageFlutter is licensed under Mulan PSL v2. You can use this software according to the terms and conditions of the Mulan PSL v2. You may obtain a copy of Mulan PSL v2 at: http://license.coscl.org.cn/MulanPSL2 THIS SOFTWARE IS PROVIDED ON AN “AS IS” BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE. See the Mulan PSL v2 for more details.
