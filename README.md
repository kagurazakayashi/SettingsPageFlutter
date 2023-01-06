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
| x                       | multiline     | 多行文本 |

### 分组 (Group)

| Settings.bundle          | MaterialApp | 功能         |
| ------------------------ | ----------- | ------------ |
| Group                    |             | 分组         |
| Type                     |             | Group        |
| Title                    | +           | 分组显示标题 |
| FooterText               | x           | 分组底部文本 |

### 多项选择框 (Multi Value)

| Settings.bundle | MaterialApp | 功能        |
| --------------- | ----------- | ----------- |
| Multi Value     |             | Widget 名称 |
| Type            |             | Multi Value |
| Identifier      | -           | 标识符      |
| Title           | +           | 标题        |
| Default Value   | +           | 默认值      |
| Titles          | +           | 标题集合    |
| Values          | +           | 值的集合    |

### 滑动条 (Slider)

| Settings.bundle          | MaterialApp | 功能        |
| ------------------------ | ----------- | ----------- |
| Slider                   | Slider      | Widget 名称 |
| Type                     |             | Slider      |
| Identifier               | -           | 标识符      |
| Default Value            | value       | 默认值      |
| Minimum Value            | min         | 最小值      |
| Maximum Value            | max         | 最大值      |
| Max Value Image Filename | x           | 最大端图片  |
| Min Value Image Filename | x           | 最小端图片  |

### 文字输入框 (TextField)

| Settings.bundle          | MaterialApp  | 功能         |
| ------------------------ | -----------  | ------------ |
| TextField                | TextField    | Widget 名称  |
| Type                     |              | TextField    |
| Identifier               | -            | 标识符       |
| Title                    | labelText    | 标题         |
| Default Value            | hintText     | 默认值       |
| Autocorrection Style     | x            | 自动纠正拼写 |
| Autocapitalization Style | x            | 自动大写     |
| Text Field Is Secure     | obscureText  | 是否密文显示 |
| keyboard Type            | keyboardType | 键盘样式     |

### 标题框 (Title)

| Settings.bundle | MaterialApp | 功能        |
| --------------- | ----------- | ----------- |
| Title           | Text        | Widget 名称 |
| Type            |             | Title       |
| Identifier      | -           | 标识符      |
| Title           | Text        | 标题文本    |
| Default Value   | x           | 默认值      |

### 开关 (Toggle Switch)

| Settings.bundle | MaterialApp | 功能        |
| --------------- | ----------- | ----------- |
| Toggle Switch   | Switch      | Widget 名称 |
| Type            |             | Title       |
| Title           | Text        | 标题文本    |
| Identifier      | -           | 标识符      |
| Default Value   | value       | 默认值      |

## LICENSE

Copyright (c) 2023 KagurazakaYashi SettingsPageFlutter is licensed under Mulan PSL v2. You can use this software according to the terms and conditions of the Mulan PSL v2. You may obtain a copy of Mulan PSL v2 at: http://license.coscl.org.cn/MulanPSL2 THIS SOFTWARE IS PROVIDED ON AN “AS IS” BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE. See the Mulan PSL v2 for more details.
