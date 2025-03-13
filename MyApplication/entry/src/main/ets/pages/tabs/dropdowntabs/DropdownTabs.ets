import { TabsContent } from "./MyNodeController"
import { hilog } from "@kit.PerformanceAnalysisKit"
import { getTabContent } from "../TabsDemo2"
import { ObservedArray } from "./CustomTabContents"
import { DropdownComp } from "./DropdownComp"

let TAG = 'DropdownTabsBar: gqz->'

@Preview
@Component
export struct DropdownTabsBar {
   @State private tabsIndex: number = 0
   @State private fontColor: string = '#182431'
   @State private selectedFontColor: string = '#007DFF'
   @StorageLink('isDropdown') @Watch('onChanged') private isDropdown: boolean = false
   private controller: TabsController = new TabsController()
   private dropdownBtnWidth: number = 50
   @State @Watch('onChanged') private tabContentNamesDisplayed: ObservedArray<string> = new ObservedArray<string>()
   @Link tabContentNamesBackup: ObservedArray<string> //作为备选项数据源
   @State private showTabContents: TabsContent[] = []
   private totalTabContents: TabsContent[] = []

   onChanged(changedVarName: string) {
      switch (changedVarName) {
         case 'tabContentNamesDisplayed': {
            hilog.debug(0, TAG, 'tabContentNamesDisplayed changed:' + this.tabContentNamesDisplayed)
         }
         case 'tabContentNamesBackup': {
            hilog.debug(0, TAG, 'tabContentNamesBackup changed:' + this.tabContentNamesBackup)
         }
         case 'isDropdown': {
            if (!this.isDropdown) {
               hilog.debug(0, TAG, 'dropdownComp was hidden')
               hilog.debug(0, TAG, 'tabContentNamesBackup: ' + this.tabContentNamesBackup.toString())
               //update showTabContents
               this.setUpShowTabContents()
            }
         }
      }
   }

   initTabContentNames() {
      if (this.tabContentNamesBackup.length > 4) {
         this.tabContentNamesDisplayed = this.tabContentNamesBackup.splice(0, 4)
      }
   }

   setUpShowTabContents() {
      this.showTabContents = []
      this.tabContentNamesDisplayed.forEach((item: string) => {
         let content = getTabContent(item)
         if (content) {
            this.showTabContents.push(content)
         }
      })
   }

   aboutToAppear(): void {
      hilog.debug(0, TAG, 'aboutToAppear:')
      setTimeout(() => {
         this.controller.setTabBarTranslate({ x: -this.dropdownBtnWidth })
      }, 100)

      this.tabContentNamesBackup.forEach((item: string) => {
         hilog.debug(0, TAG, 'tabContentNames: ' + item)
         let content = getTabContent(item)
         if (content != undefined) {
            this.totalTabContents.push(content)
         }
      })

      this.initTabContentNames()
      this.setUpShowTabContents
   }

   @Builder
   tabBuilder(index: number, name: string) {
      Column() {
         Text(name)
            .fontColor(this.tabsIndex === index ? this.selectedFontColor : this.fontColor)
            .fontSize(this.tabsIndex === index ? 18 : 16)
            .fontWeight(this.tabsIndex === index ? 600 : 300)
            .lineHeight(22)
            .margin({ top: 17, bottom: 7 })
         Divider()
            .strokeWidth(2)
            .color('#007DFF')
            .opacity(this.tabsIndex === index ? 1 : 0)
      }
      .width('25%')
      .height(this.dropdownBtnWidth)
   }

   build() {
      Stack({ alignContent: Alignment.TopEnd }) {
         Tabs({ index: this.tabsIndex, controller: this.controller }) {
            ForEach(this.showTabContents, (item: TabsContent, index: number) => {
               TabContent() {
                  NodeContainer(item.nodeCtrl)
               }.tabBar(this.tabBuilder(index, item.name))
            })
         }
         .barMode(BarMode.Scrollable, { margin: this.dropdownBtnWidth })
         .barHeight(this.dropdownBtnWidth)
         .onChange((index: number) => {
            // animateTo({ duration: 200 }, () => {
            this.tabsIndex = index
            this.controller.changeIndex(index)
            // })
         })
         .onAnimationStart((index, targetIndex) => {
            animateTo({ duration: 300 }, () => {
               this.tabsIndex = targetIndex
               // this.controller.changeIndex(targetIndex)
            })
         })

         // the dropdown view will cover on tabcontents
         if (this.isDropdown) {
            DropdownComp({
               tabContentNamesDisplayed: this.tabContentNamesDisplayed,
               tabContentNamesBackup: this.tabContentNamesBackup
            })
         }

         Image(this.isDropdown ? $rawfile('icon/arrow_up.png') : $rawfile('icon/arrow_down.png'))
            .width(this.dropdownBtnWidth)
            .height(this.dropdownBtnWidth)
            .backgroundColor('white')
            .onClick(() => {
               animateTo({ duration: 200 }, () => {
                  this.isDropdown = !this.isDropdown
               })
            })
      }
      .backgroundColor('white')
      .borderWidth(1)
      .borderColor('red')
   }
}