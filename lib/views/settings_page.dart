import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pica_comic/network/update.dart';
import 'package:pica_comic/views/base.dart';
import 'package:pica_comic/views/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RadioLogic extends GetxController{
  int value = int.parse(appdata.appChannel)-1;
  void change(int i){
    value = i;
    appdata.appChannel = (i+1).toString();
    appdata.writeData();
    update();
  }
}

class ModeRadioLogic2 extends GetxController{
  int value = appdata.getSearchMod();
  void change(int i){
    value = i;
    appdata.saveSearchMode(i);
    update();
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pageChangeValue = appdata.settings[0]=="1";
  bool checkUpdateValue = appdata.settings[2]=="1";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            centerTitle: true,
            title: const Text("设置"),
          ),
          SliverToBoxAdapter(
            child: Card(
              elevation: 0,
              child: Column(
                children: [
                  const ListTile(
                    title: Text("浏览"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.hub_outlined),
                    title: const Text("设置分流"),
                    trailing: const Icon(Icons.arrow_right),
                    onTap: (){
                      Get.put(RadioLogic());
                      showDialog(context: context, builder: (BuildContext context) => Dialog(
                        child: GetBuilder<RadioLogic>(builder: (radioLogic){
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const ListTile(title: Text("选择分流"),),
                              ListTile(
                                trailing: Radio<int>(value: 0,groupValue: radioLogic.value,onChanged: (i){
                                  radioLogic.change(i!);
                                },),
                                title: const Text("分流1"),
                                onTap: (){
                                  radioLogic.change(0);
                                },
                              ),
                              ListTile(
                                trailing: Radio<int>(value: 1,groupValue: radioLogic.value,onChanged: (i){
                                  radioLogic.change(i!);
                                },),
                                title: const Text("分流2"),
                                onTap: (){
                                  radioLogic.change(1);
                                },
                              ),
                              ListTile(
                                trailing: Radio<int>(value: 2,groupValue: radioLogic.value,onChanged: (i){
                                  radioLogic.change(i!);
                                },),
                                title: const Text("分流3"),
                                onTap: (){
                                  radioLogic.change(2);
                                },
                              ),
                            ],
                          );
                        },),
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.switch_left),
                    title: const Text("点击屏幕左右区域翻页"),
                    trailing: Switch(
                      value: pageChangeValue,
                      onChanged: (b){
                        b?appdata.settings[0] = "1":appdata.settings[0]="0";
                        setState(() {
                          pageChangeValue = b;
                        });
                        appdata.writeData();
                      },
                    ),
                    onTap: (){},
                  ),
                  ListTile(
                    leading: const Icon(Icons.manage_search_outlined),
                    trailing: const Icon(Icons.arrow_right),
                    title: const Text("设置搜索及分类排序模式"),
                    onTap: (){
                      showDialog(context: context, builder: (context){
                        Get.put(ModeRadioLogic2());
                        return Dialog(
                          child: GetBuilder<ModeRadioLogic2>(builder: (radioLogic){
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const ListTile(title: Text("选择搜索及分类排序模式"),),
                                ListTile(
                                  trailing: Radio<int>(value: 0,groupValue: radioLogic.value,onChanged: (i){
                                    radioLogic.change(i!);

                                  },),
                                  title: const Text("新书在前"),
                                  onTap: (){
                                    radioLogic.change(0);
                                  },
                                ),
                                ListTile(
                                  trailing: Radio<int>(value: 1,groupValue: radioLogic.value,onChanged: (i){
                                    radioLogic.change(i!);
                                  },),
                                  title: const Text("旧书在前"),
                                  onTap: (){
                                    radioLogic.change(1);
                                  },
                                ),
                                ListTile(
                                  trailing: Radio<int>(value: 2,groupValue: radioLogic.value,onChanged: (i){
                                    radioLogic.change(i!);
                                    appdata.appChannel = (i+1).toString();
                                  },),
                                  title: const Text("最多喜欢"),
                                  onTap: (){
                                    radioLogic.change(2);
                                  },
                                ),
                                ListTile(
                                  trailing: Radio<int>(value: 3,groupValue: radioLogic.value,onChanged: (i){
                                    radioLogic.change(i!);
                                    appdata.appChannel = (i+1).toString();
                                  },),
                                  title: const Text("最多指名"),
                                  onTap: (){
                                    radioLogic.change(3);
                                  },
                                ),
                              ],
                            );
                          },),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverToBoxAdapter(
              child: Card(
                elevation: 0,
                child: Column(
                  children: [
                    const ListTile(
                      title: Text("关于"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text("PicaComic"),
                      subtitle: const SelectableText("本软件仅用于学习交流"),
                      onTap: (){
                        showMessage(context, "禁止涩涩");
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.update),
                      title: const Text("检查更新"),
                      subtitle: const Text("当前: v1.1.6"),
                      onTap: (){
                        showMessage(context, "正在检查更新");
                        checkUpdate().then((b){
                          if(b==null){
                            showMessage(context, "网络错误");
                          } else if(b){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                content: const Text("有可用更新, 是否下载?"),
                                actions: [
                                  TextButton(onPressed: (){Get.back();}, child: const Text("取消")),
                                  TextButton(
                                      onPressed: (){
                                        getDownloadUrl().then((s){
                                          launchUrlString(s,mode: LaunchMode.externalApplication);
                                        });
                                      },
                                      child: const Text("下载"))
                                ],
                              );
                            });
                          }else{
                            showMessage(context, "已是最新版本");
                          }
                        });
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.security_update),
                      title: const Text("启动时检查更新"),
                      trailing: Switch(
                        value: checkUpdateValue,
                        onChanged: (b){
                          b?appdata.settings[2] = "1":appdata.settings[2]="0";
                          setState(() {
                            checkUpdateValue = b;
                          });
                          appdata.writeData();
                        },
                      ),
                      onTap: (){},
                    ),
                    ListTile(
                      leading: const Icon(Icons.code),
                      title: const Text("项目地址"),
                      subtitle: const Text("https://github.com/wgh136/PicaComic"),
                      onTap: (){
                        launchUrlString("https://github.com/wgh136/PicaComic",mode: LaunchMode.externalApplication);
                      },
                    ),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}