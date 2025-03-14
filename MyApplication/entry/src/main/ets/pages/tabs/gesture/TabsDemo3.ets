import { DropdownTabs } from '../dropdowntabs/DropdownTabs';
import { TabsContent } from '../dropdowntabs/DropdownTabsUtils';
import {
   OuterTabContentNodeCtrl,
   OuterTabContentNodeCtrl2,
   ObservedArray
} from '../dropdowntabs/CustomTabContents';
import { ContentType } from '../dropdowntabs/DropdownTabsUtils'
import { hilog } from '@kit.PerformanceAnalysisKit';

let TAG = 'TabsDemo3: gqz->'

// region get TabContent

export function getTabContent(name: string): TabsContent | undefined {
   switch (name) {
      case '歌曲':
         return {
            name: name, type: ContentType.TYPE_TABCONTENT,
            nodeCtrl: new OuterTabContentNodeCtrl2(name)
         }
      case '文件夹':
         return {
            name: name, type: ContentType.TYPE_TABCONTENT,
            nodeCtrl: new OuterTabContentNodeCtrl2(name)
         }
      case '专辑':
         return {
            name: name, type: ContentType.TYPE_TABCONTENT,
            nodeCtrl: new OuterTabContentNodeCtrl2(name)
         }
      case '艺术家':
         return {
            name: name, type: ContentType.TYPE_TABCONTENT,
            nodeCtrl: new OuterTabContentNodeCtrl2(name)
         }
      case '风格':
         return {
            name: name, type: ContentType.TYPE_TABCONTENT,
            nodeCtrl: new OuterTabContentNodeCtrl2(name)
         }
      case '私有云':
         return {
            name: name, type: ContentType.TYPE_TABCONTENT,
            nodeCtrl: new OuterTabContentNodeCtrl2(name)
         }
      case '专辑艺术家':
         return {
            name: name, type: ContentType.TYPE_TABCONTENT,
            nodeCtrl: new OuterTabContentNodeCtrl2(name)
         }
      default:
         return
   }
}

// endregion

@Entry
@Component
export struct TabsDemo3 {
   @State @Watch('onChanged') tabContentNames: ObservedArray<string> =
      new ObservedArray<string>('歌曲', '文件夹', '专辑', '艺术家', '风格', '私有云', '专辑艺术家')
   @State @Watch('onChanged') tabContentNames2: ObservedArray<string> =
      new ObservedArray<string>('歌曲', '文件夹', '专辑', '艺术家', '风格', '私有云', '专辑艺术家')
   @StorageLink('isDropdown') isDropdown: boolean = false
   //
   controller = new TabsController()
   @State tabsIndex: number = 0

   onChanged() {
      hilog.debug(0, TAG, 'tabContentNames onChanged: ' + this.tabContentNames.toString())
   }

   @Builder
   subTabBuilder(index: number, name: string) {
      Column() {
         Text(name)
            .fontColor(this.tabsIndex === index ? '#ff127fb8' : '#ff719bb5')
            .fontSize(16)
            .fontWeight(this.tabsIndex === index ? 500 : 300)
            .lineHeight(22)
            .margin({ top: 17, bottom: 7 })
         Divider()
            .strokeWidth(2)
            .color('#007DFF')
            .opacity(this.tabsIndex === index ? 1 : 0)
      }.width('25%')
   }

   build() {
      Column() {
         Tabs({ controller: this.controller, index: this.tabsIndex }) {
            TabContent() {
               DropdownTabs({
                  tabContentNamesBackup: this.tabContentNames,
                  leftPanGestureCB: () => {
                     hilog.debug(0, TAG, 'leftPanGestureCB: ')
                     // sliding to next TabContent
                     animateTo({ duration: 300 }, () => {
                        this.tabsIndex++
                     })
                  },
                  rightPanGestureCB: () => {
                     hilog.debug(0, TAG, 'rightPanGestureCB: ')
                  }
               })
            }.tabBar(this.subTabBuilder(0, 'Tab 1')).backgroundColor('#fff')

            TabContent() {
               DropdownTabs({
                  tabContentNamesBackup: this.tabContentNames2,
                  leftPanGestureCB: () => {
                     hilog.debug(0, TAG, 'leftPanGestureCB: ')
                  },
                  rightPanGestureCB: () => {
                     hilog.debug(0, TAG, 'rightPanGestureCB: ')
                     // sliding to prev TabContent
                     animateTo({ duration: 300 }, () => {
                        this.tabsIndex--
                     })
                  }
               })
            }.tabBar(this.subTabBuilder(1, 'Tab 2'))
         }
         .barMode(BarMode.Fixed)
         .barWidth('100%')
         .barHeight(50)
         .animationDuration(250)
         .onChange((index: number) => {
            hilog.debug(0, TAG, 'onChange: ' + index)
            // currentIndex控制TabContent显示页签
            // animateTo({ duration: 300 }, () => {
            // this.tabsIndex = index
            // this.controller.changeIndex(index)
            // })
         })
      }
      .backgroundColor('#ddd')
   }
}
