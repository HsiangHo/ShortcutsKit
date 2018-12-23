# ShortcutsKit

[![Travis](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/HsiangHo/ShortcutsKit)
[![Jenkins](https://img.shields.io/badge/license-MIT-red.svg)](https://github.com/HsiangHo/ShortcutsKit/blob/master/LICENSE)
[![Contributions](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/HsiangHo/ShortcutsKit/issues)
[![Platform](https://img.shields.io/badge/platform-macOS-yellow.svg)]()
[![Language](https://img.shields.io/badge/Language-Objective--C-yellowgreen.svg)]()  

[中文版](https://github.com/HsiangHo/ShortcutsKit/blob/master/README_zh.md)  

📦 ShortcutsKit is an easy way for developers to register/unregister/serialize/deserialize a hotkey and display hotkeys with customization.  

![](https://github.com/HsiangHo/ShortcutsKit/blob/master/doc/logo.png?raw=true "Optional Title")

## Installation
Clone the rep, build the ShortcutsKit or copy all the source files into your project.
  
## Features
- [x] Customization and Configuration to your needs
- [x] Easy to register/unregister hotkeys
- [x] Serialize/Deserialize keyCombo object

## Example

To run the example project, clone the repo, build and run the target 'ShortcutsDemo'.

## Getting started  

- Create a keyCombo object
```
//Create a keyCombo object for "shift + option + control + space"
    SCKeyCombo *keyCombo = [[SCKeyCombo alloc] initWithKeyCode:kVK_Space keyModifiers:shiftKey + optionKey + controlKey];
    
    //Serialize keyCombo object
    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:keyCombo] forKey:@"keyCombo"];
    
    //Deserialization keyCombo object
    SCKeyCombo *keyCombo2 = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"keyCombo"]];
    NSLog(@"%@",[keyCombo2 stringForKeyCombo]);
```

- Create a hotkey object
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

- Register/Unregister a hotkey object
```
...
    //Register hotkey object
    [shortcut register];
    
    //Invoke hotkey object action
    [shortcut invoke];
    
    //Unregister hotkey object
    [shortcut unregister];
```

- Display a hotkey object

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

- Using SCHotkeyManager

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

## Requirements
macOS 10.7 and above  
Xcode 8.0+

## Contributing
Contributions are very welcome 🙌 🤓

## Screenshots

