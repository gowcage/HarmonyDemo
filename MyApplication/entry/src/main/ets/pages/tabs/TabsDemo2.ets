import { DropdownTabsBar } from './dropdowntabs/DropdownTabs';
import { TabsContent } from './dropdowntabs/MyNodeController';
import {
   OuterTabContentNodeCtrl,
   OuterTabContentNodeCtrl2,
   ObservedArray
} from './dropdowntabs/CustomTabContents';
import { ContentType } from './dropdowntabs/MyNodeController'
import { hilog } from '@kit.PerformanceAnalysisKit';

let TAG = 'TabsDemo2: gqz->'

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
export struct TabsDemo2 {
   @State @Watch('onChanged') tabContentNames: ObservedArray<string> =
      new ObservedArray<string>('歌曲', '文件夹', '专辑', '艺术家', '风格', '私有云', '专辑艺术家')
   @StorageLink('isDropdown') isDropdown: boolean = false

   onChanged() {
      hilog.debug(0, TAG, 'tabContentNames onChanged: ' + this.tabContentNames.toString())
   }

   build() {
      Column() {
         DropdownTabsBar({ tabContentNamesBackup: this.tabContentNames })
      }
   }
}
