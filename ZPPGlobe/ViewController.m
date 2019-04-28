//
//  ViewController.m
//  ZPPGlobe
//
//  Created by figaro on 2019/4/18.
//  Copyright © 2019 figaro. All rights reserved.
//

#import "ViewController.h"
#import "DragDropImageView.h"
#import "XcodeEditor.h"
@interface ViewController()<DragDropViewDelegate>

@property (weak) IBOutlet NSTextField *label;
@property (weak) IBOutlet DragDropImageView *imageView;

@property (nonatomic, strong) NSString *projectPath;

/**
 项目的绝对路径，方便获得绝对路径
 */
@property (nonatomic, strong) NSString *projectPrefixPath;
@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, strong) XCProject *project;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    
   
}
-(void)dragDropViewFileList:(NSArray *)fileList{
    //如果数组不存在或为空直接返回不做处理（这种方法应该被广泛的使用，在进行数据处理前应该现判断是否为空。）
    if(!fileList || [fileList count] <= 0)return;
    //在这里我们将遍历这个数字，输出所有的链接，在后台你将会看到所有接受到的文件地址

        NSLog(@">>> %@",[fileList objectAtIndex:0]);
        self.projectPath = [fileList objectAtIndex:0];
        NSArray *array = [[fileList objectAtIndex:0] componentsSeparatedByString:@"/"];
        self.projectName = array[array.count -2];
    for (int i = 0; i < array.count -1; i++) {
        if (i == 0) {
            self.projectPrefixPath = [NSString stringWithFormat:@"%@",array[i]];
        } else {
            self.projectPrefixPath = [NSString stringWithFormat:@"%@/%@",self.projectPrefixPath,array[i]];
        }
        
    }
    self.project = [XCProject projectWithFilePath:self.projectPath];

    
//        不能编辑
        self.label.editable = false;
    
   
    
//    [self addXcodeFile];
    [self changeXcodeWithPath:nil];
}
-(void)testAdd{
    self.project = [XCProject projectWithFilePath:self.projectPath];
    
}
//xcode文件添加
-(void)addXcodeFile{
//    绝对j路径
    self.project = [XCProject projectWithFilePath:self.projectPath];
//    之后的都是相对路径：这里是指strings文件的文件夹地址，也是一个group
//    要放的文件目录
    NSString *path = [self openPath];
    XCGroup *language = [self.project groupWithPathFromRoot:path];
    NSString *kKeyStringsFile = @"Localizable.strings";
    NSString *chooseLanguage = @"it";
    NSString *myFiledFolder = [NSString stringWithFormat:@"%@.lproj/Localizable.strings",chooseLanguage];
//    生成文件
    XCSourceFileDefinition *mainString = [[XCSourceFileDefinition alloc] initWithName:kKeyStringsFile text:@"测试文件生成" type:PropertyList];
//    生成语言专属group
//    NSString *fileKey = [[XCKeyBuilder forItemNamed:kKeyStringsFile] build];
   
//    XCGroup *mainGroup = [XCGroup groupWithProject:self.project key:fileKey alias:kKeyStringsFile path:myFiledFolder children:(NSArray<id<XcodeGroupMember>> *)];
//    添加到group中

     NSLog(@"add member-- %@",[language memberWithDisplayName:@"Localizable.strings"]);
    XCGroup *stringGroup = [self.project groupForGroupMemberWithKey:[language memberWithDisplayName:@"Localizable.strings"].key];
     [stringGroup addSourceFile:mainString];
   
    
    NSArray *files = [self.project.files filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(XCSourceFile *evaluatedObject, NSDictionary *bindings) {
        return [[NSSet setWithObjects:kKeyStringsFile, nil] containsObject:[evaluatedObject.name lastPathComponent] ];
    }]];
    
//    判断文件是否存在
        if (files != nil && ![files isKindOfClass:[NSNull class]] && files.count != 0) {
    //        添加了国际化文件
            NSLog(@"not null");
            self.imageView.image = [NSImage imageNamed:@"xcode"];
            self.label.stringValue = self.projectName;
    //        [self writetofile:@"hahah" withLanuage:@"fr" withPath:openPath];
    
        } else {
    //        没有添加国际化文件的情况
            NSLog(@"null");
    
//            [self openAlertPanel];
    //        NSString *openPath = [self openPath];
    //        [self writetofile:@"hahah" withLanuage:@"fr" withPath:openPath];
            XCGroup *lang = [self.project groupWithPathFromRoot:kKeyStringsFile];
    
    //        NSString *relretivePath = [NSString stringWithFormat:@"%@.lproj/%@",@"fr",kKeyStringsFile];
    //        [lang addFileReference:relretivePath withType:LocalizableStrings];
    
    
    //        XCSourceFile* sourceFile = [project fileWithName:kKeyStringsFile];
    //        XCTarget* examples = [project targetWithName:@"fr"];
    //        [examples addMember:sourceFile];
    //        [project save];
    
        }
    
    
    
    for(XCSourceFile *file in files){
        NSLog(@"file -- %@",file);
        //    指定target
        XCTarget* examples = [self.project targetWithName:self.projectName];
        [examples addMember:file];
    };


    [self.project save];
    
    self.imageView.image = [NSImage imageNamed:@"xcode"];
    self.label.stringValue = self.projectName;
    
}



//xcode工程文件编辑
-(void)changeXcodeWithPath:(NSString *)path{
//    查看工程项目文件结构
//    NSMutableDictionary *xcodeData = [[NSMutableDictionary alloc] initWithContentsOfFile:[self.projectPath stringByAppendingPathComponent:@"project.pbxproj"]];
//    NSLog(@" date -- %@",xcodeData);
    
//   self.project = [XCProject projectWithFilePath:self.projectPath];
    NSString *kKeyStringsFile = @"Localizable.strings";
    NSArray *files = [self.project.files filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(XCSourceFile *evaluatedObject, NSDictionary *bindings) {
        return [[NSSet setWithObjects:kKeyStringsFile, nil] containsObject:[evaluatedObject.name lastPathComponent] ];
    }]];
//    if (files != nil && ![files isKindOfClass:[NSNull class]] && files.count != 0) {
////        添加了国际化文件
//        NSLog(@"not null");
//        self.imageView.image = [NSImage imageNamed:@"xcode"];
//        self.label.stringValue = self.projectName;
////        [self writetofile:@"hahah" withLanuage:@"fr" withPath:openPath];
//
//    } else {
////        没有添加国际化文件的情况
//        NSLog(@"null");
//
//        [self openAlertPanel];
////        NSString *openPath = [self openPath];
////        [self writetofile:@"hahah" withLanuage:@"fr" withPath:openPath];
////        XCGroup *lang = [project groupWithPathFromRoot:kKeyStringsFile];
//
////        NSString *relretivePath = [NSString stringWithFormat:@"%@.lproj/%@",@"fr",kKeyStringsFile];
////        [lang addFileReference:relretivePath withType:LocalizableStrings];
//
//
////        XCSourceFile* sourceFile = [project fileWithName:kKeyStringsFile];
////        XCTarget* examples = [project targetWithName:@"fr"];
////        [examples addMember:sourceFile];
////        [project save];
//
//    }
    XCGroup *parentGroup;
    NSString *allPath;
    for(XCSourceFile *file in files)
    {

        NSString *fullpath =[file pathRelativeToProjectRoot];
        NSLog(@"path -- %@",fullpath);
       
//        allPath = [NSString stringWithFormat:@"%@%@",path,fullpath];
//        NSLog(@"allpath -- %@",allPath);
        //组信息
        XCGroup *group = [self.project groupForGroupMemberWithKey:file.key];
        NSLog(@"group== %@",group);
        parentGroup = [[self.project groupForGroupMemberWithKey:file.key] parentGroup];
        NSLog(@"parentGroup -- %@",parentGroup.displayName);
        allPath = [NSString stringWithFormat:@"%@%@",path,parentGroup.displayName];
        
        
        //语言名称信息
        NSString *language = [[[file.name stringByDeletingLastPathComponent] lastPathComponent] stringByDeletingPathExtension];
    }
    
    NSLog(@"members -- %@",[parentGroup members][0]);
}
//保存文件到项目
-(void)writetofile:(NSString *)string withLanuage:(NSString *)lanuage withPath:(NSString *)path{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    //创建NSFileManager实例
    //获得文件路径，第一个参数是要定位的路径 NSApplicationDirectory-获取应用程序路径，NSDocumentDirectory-获取文档路径
    //第二个参数是要定义的文件系统域
//    NSArray *paths = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    //沙盒路径
//    NSURL *path = [paths objectAtIndex:0];
    NSURL *pathURL = [NSURL URLWithString:path];
    //要查找的文件
    NSString *myFiledFolder = [pathURL.relativePath stringByAppendingFormat:@"/%@.lproj",lanuage];
    
    NSString *myFiled = [myFiledFolder stringByAppendingFormat:@"/Localizable.strings"];
    //判断文件是否存在
    BOOL result = [fm fileExistsAtPath:myFiled];
    //如果文件不存在
    if (!result) {
        NSString *content = string;
        //创建文件夹
        [fm createDirectoryAtPath:myFiledFolder withIntermediateDirectories:YES attributes:nil error:nil];
        //文件
        BOOL isCreate = [fm createFileAtPath:myFiled contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        if (isCreate) {
            NSLog(@"创建成功");
            NSError * error;
            [string writeToFile:myFiled atomically:YES encoding:NSUTF8StringEncoding error:&error];
            
            if (error) {
                NSLog(@"save error:%@",error.description);
            }
        }
        else{
            NSLog(@"🌺 创建失败");
        }
    }
    
    NSLog(@"OUTPUT:%@",myFiled);
    
}
//没有文件的警告
- (void)openAlertPanel{
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.icon = [NSImage imageNamed:@"xcode"];
    
    //增加一个按钮
    [alert addButtonWithTitle:@"OK"];//1000
    
    //提示的标题
    [alert setMessageText:@"❌国际化进程错误"];
    //提示的详细内容
    [alert setInformativeText:@"没有在xcode工程中初始化文件，请添加所有需要国际化的语言文件！"];
    //设置告警风格
    [alert setAlertStyle:NSAlertStyleWarning];
    
    //开始显示告警
    [alert beginSheetModalForWindow:[self.view window]
                  completionHandler:^(NSModalResponse returnCode){
                      //用户点击告警上面的按钮后的回调
                      NSLog(@"returnCode : %ld",(long)returnCode);
                  }
     ];
}
//获取相对路径
-(NSString *)openPath{
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:YES];
    [oPanel setCanChooseFiles:NO];
    if ([oPanel runModal] == NSModalResponseOK) {
        NSString *path = [[[[[oPanel URLs] objectAtIndex:0] absoluteString] componentsSeparatedByString:@":"] lastObject];
        path = [[path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByExpandingTildeInPath];
        NSLog(@"绝对路径：%@",path);
        NSString *prefixPath = [[path stringByReplacingOccurrencesOfString:self.projectPrefixPath withString:@""] substringFromIndex:1];
        NSLog(@"相对路径：%@",prefixPath);
        return prefixPath;
    }else{
        return nil;
    }
}
@end
