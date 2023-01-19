# SettingsPageFlutter

从 iOS 的 plist 设置配置文件生成一个选项设置页

**没有做完，请勿使用。**

## Settings.bundle 和 MaterialApp 属性对照

实现方式：

- `-` 表示仅在事件回调中体现
- `+` 会进行额外的实现
- `x` 表示不支持

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

`*`: 本插件特有项， Settings.bundle 中没有。

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

`*`: 本插件特有项， Settings.bundle 中没有。

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
