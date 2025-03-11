import { LengthMetrics, NodeController } from "@kit.ArkUI"
import { OuterTabContentNodeCtrl, OuterTabContentNodeCtrl2 } from "./tabcontents/OuterTabContent1"

let TAG = 'EncapsulationTabsBar: ->'

class Params {
   text: string = "this is a text in Params"
   num: number = 123
}

@Preview
@Component
export struct EncapsulationTabsBar {
   @State tabContents: string[] = ['Tab1', 'Tab2', 'Tab3', 'Tab4', 'Tab5', 'Tab6']
   @State tabsIndex: number = 0
   @State fontColor: string = '#182431'
   @State selectedFontColor: string = '#007DFF'
   @State isDropdown: boolean = false
   private controller: TabsController = new TabsController()
   private dropdownBtnWidth: number = 50
   private myNodeController: OuterTabContentNodeCtrl = new OuterTabContentNodeCtrl()
   private myNodeController2: OuterTabContentNodeCtrl2<Params> = new OuterTabContentNodeCtrl2(new Params())
   private myNodeController3: OuterTabContentNodeCtrl2<string> = new OuterTabContentNodeCtrl2(new Params().text)
   private myNodeController4: OuterTabContentNodeCtrl2<number> = new OuterTabContentNodeCtrl2(new Params().num)

   aboutToAppear(): void {
      setTimeout(() => {
         this.controller.setTabBarTranslate({ x: -this.dropdownBtnWidth })
      })
   }

   @Builder
   dropdownView() {
      Column() {
         Text('DropdownView').fontSize(LengthMetrics.fp(50).value).fontColor('white')
      }
      .width('100%').height('100%')
      .backgroundColor('blue')
   }

   @Builder
   aaa() {
      Column().width('100%').height('100%').backgroundColor('red')
   }

   @Builder
   bbb() {
      Column().width('100%').height('100%').backgroundColor('green')
   }

   @Builder
   tabBuilder(index: number, name: string) {
      Column() {
         Text(name)
            .fontColor(this.tabsIndex === index ? this.selectedFontColor : this.fontColor)
            .fontSize(16)
            .fontWeight(this.tabsIndex === index ? 500 : 300)
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
            ForEach(this.tabContents, (item: string, index: number) => {
               TabContent() {
                  if (index === 0) {
                     NodeContainer(this.myNodeController)
                  } else if (index === 1) {
                     NodeContainer(this.myNodeController2)
                  } else if (index === 2) {
                     NodeContainer(this.myNodeController3)
                  } else if (index === 3) {
                     NodeContainer(this.myNodeController4)
                  } else if (index === 4) {
                     this.aaa()
                  } else if (index === 5) {
                     this.bbb()
                  }
               }.tabBar(this.tabBuilder(index, item))
            })
         }
         .barMode(BarMode.Scrollable, { margin: this.dropdownBtnWidth })
         .barHeight(this.dropdownBtnWidth)
         .onChange((index: number) => {
            this.tabsIndex = index
            this.controller.changeIndex(index)
         })

         // mask modify view
         if (this.isDropdown) {
            this.dropdownView()
         }

         Image(this.isDropdown ? $rawfile('icon/arrow_up.png') : $rawfile('icon/arrow_down.png'))
            .width(this.dropdownBtnWidth)
            .height(this.dropdownBtnWidth)
            .borderColor('black')
            .borderWidth(1)
            .onClick(() => {
               console.log('gqz', 'click arrow down')
               this.isDropdown = !this.isDropdown
            })
      }
      .backgroundColor('gray')
      .borderWidth(1)
      .borderColor('red')
   }
}