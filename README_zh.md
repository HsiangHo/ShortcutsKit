# ShortcutsKit

[![Travis](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/HsiangHo/ShortcutsKit)
[![Jenkins](https://img.shields.io/badge/license-MIT-red.svg)](https://github.com/HsiangHo/ShortcutsKit/blob/master/LICENSE)
[![Contributions](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/HsiangHo/ShortcutsKit/issues)
[![Platform](https://img.shields.io/badge/platform-macOS-yellow.svg)]()
[![Language](https://img.shields.io/badge/Language-Objective--C-yellowgreen.svg)]()  

📦 ShortcutsKit可以简单方便注册/反注册/序列化/反序列化全局快捷键，自定义UI进行显示快捷键和修改快捷键。

![](https://github.com/HsiangHo/ShortcutsKit/blob/master/doc/logo.png?raw=true "Optional Title")

## 如何安装
克隆仓库到本地，将ShortcutsKit工程加入到你的项目。
  
## 功能
- [x] 根据你的需要进行自定义
- [x] 简单方便的注册和反注册快捷键
- [x] 序列化和反序列化键组对象

## 栗子

在工程文件里，编译执行'ShortcutsDemo'这个目标程序，方可见demo.

## 如何使用

- 创建键组对象
```
//Create a keyCombo object for "shift + option + control + space"
    SCKeyCombo *keyCombo = [[SCKeyCombo alloc] initWithKeyCode:kVK_Space keyModifiers:shiftKey + optionKey + controlKey];
    
    //Serialize keyCombo object
    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:keyCombo] forKey:@"keyCombo"];
    
    //Deserialization keyCombo object
    SCKeyCombo *keyCombo2 = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"keyCombo"]];
    NSLog(@"%@",[keyCombo2 stringForKeyCombo]);
```

- 创建快捷键对象
```
...

//Create a hotkey object from a keyCombo object
    //Using block
    SCHotkey *shortcut = [[SCHotkey alloc] initWithKeyCombo:keyCombo2 identifier:@"shortcut" handler:^(SCHotkey * _Nonnull hotkey) {
        NSLog(@"shortcut has been called");
    }];
    [shortcut register];
    
    //Using selector
    SCKeyCombo *keyCombo3 = [[SCKeyCombo alloc] initWithKeyCode: kVK_ANSI_B keyModifiers: optionKey + controlKey];
    SCHotkey *shortcut2 = [[SCHotkey alloc]initWithKeyCombo:keyCombo3 identifier:@"shortcut2" target:self action:@selector(shortcut2Callback)];
    
```

- 注册和反注册快捷键
```
...
    //Register hotkey object
    [shortcut register];
    
    //Invoke hotkey object action
    [shortcut invoke];
    
    //Unregister hotkey object
    [shortcut unregister];
```

- 在UI展示快捷键

```
...
    //Create a keyComboView to show the keyCombo
    SCKeyComboView *keyComboView = [SCKeyComboView standardKeyComboView];
    //Cunstomize keyComboView
    [keyComboView setOnTintColor:[NSColor redColor]];
    //Set delegate to handle keyconbo changed notification
    [keyComboView setDelegate:(id<SCKeyComboViewDelegate>)self];
    [keyComboView setKeyCombo:[shortcut keyCombo]];
    
```

- 使用快捷键管理器

```
...

    //Register with hotkey object
    [[SCHotkeyManager sharedManager] registerWithHotkey:shortcut];
    //Unregister with identifier
    [[SCHotkeyManager sharedManager] unregisterWithIdentifier:@"shortcut"];
    //Unregister with hotkey object
    [[SCHotkeyManager sharedManager] unregisterWithHotkey:shortcut];
    //Unregister all hotkey objects
    [[SCHotkeyManager sharedManager] unregisterAllHotkeys];

```

## 使用环境
macOS 10.7 and above  
Xcode 8.0+

## 如何贡献
任何问题欢迎issue, PRs 🙌 🤓

## 屏幕截图


