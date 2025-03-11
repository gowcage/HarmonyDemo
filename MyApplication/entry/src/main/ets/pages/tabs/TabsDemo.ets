import { Music } from './Music';
import { router } from '@kit.ArkUI';
import hilog from '@ohos.hilog';
import { JSON, taskpool } from '@kit.ArkTS';
import { BusinessError, emitter } from '@kit.BasicServicesKit';

let TAG = 'TabsDemo: -> '

export interface SharedAction {
   changeParentTabs: (index: number) => void
}

let innerEvent: emitter.InnerEvent = {
   eventId: 1
}

// 定义一个@Concurrent任务，给taskpool执行
@Concurrent
function sendSetTabsControllerOffsetXEvent() {
   let TAG = 'TabsDemo: ->'
   hilog.debug(0, TAG, 'send innerEvent')
   let innerEvent: emitter.InnerEvent = {
      eventId: 1
   }
   emitter.emit(innerEvent) // 发送事件
}


@Entry
@Component
export struct TabsDemo {
   @State fontColor: string = '#182431'
   @State selectedFontColor: string = '#007DFF'
   @State currentIndex: number = 0
   @State currentSubIndex: number = 0
   private controller: TabsController = new TabsController()
   private controller2: TabsController = new TabsController()
   //
   private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left, distance: 1 });
   //
   @Provide changeTabHandler: SharedAction = {
      changeParentTabs: (index: number): void => {
         // animateTo({ duration: 300 }, () => {
         this.controller.changeIndex(index)
         // })
      }
   }

   aboutToAppear(): void {
      let params = router.getParams()
      hilog.debug(0, TAG, 'router.Params: ' + JSON.stringify(params))

      // 订阅innerEvent事件
      emitter.on(innerEvent, () => {
         hilog.debug(0, TAG, 'received innerEvent')
         this.controller2.setTabBarTranslate({ x: -40 }) // 在aboutToAppear()中设置无效，页面还没渲染完
      })

      // 发送延时任务
      let task = new taskpool.Task(sendSetTabsControllerOffsetXEvent)
      taskpool.executeDelayed(100, task).then(() => {
         hilog.debug(0, TAG, 'task done')
      }).catch((err: BusinessError) => {
         hilog.debug(0, TAG, 'task error: ' + err)
      })
   }

   @Builder
   tabBuilder(index: number, name: string) {
      Column() {
         Text(name)
            .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
            .fontSize(16)
            .fontWeight(this.currentIndex === index ? 500 : 300)
            .lineHeight(22)
            .margin({ top: 17, bottom: 7 })
         Divider()
            .strokeWidth(2)
            .color('#007DFF')
            .opacity(this.currentIndex === index ? 1 : 0)
      }.width('100%')
   }

   @Builder
   subTabBuilder(index: number, name: string) {
      Column() {
         Text(name)
            .fontColor(this.currentSubIndex === index ? this.selectedFontColor : this.fontColor)
            .fontSize(16)
            .fontWeight(this.currentSubIndex === index ? 500 : 300)
            .lineHeight(22)
            .margin({ top: 17, bottom: 7 })
         Divider()
            .strokeWidth(2)
            .color('#007DFF')
            .opacity(this.currentSubIndex === index ? 1 : 0)
      }.width('25%')
   }

   build() {
      Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {

         TabContent() {

            Tabs({ barPosition: BarPosition.End, index: this.currentSubIndex, controller: this.controller2 }) {

               TabContent() {
                  Column() {
                     Text('SubTab 1')
                     Button().onClick(() => {
                        this.controller2.setTabBarTranslate({ x: -40 })
                     })
                  }
                  .width('100%')
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundColor('#ffb3a288')
               }.tabBar(this.subTabBuilder(0, 'SubTab 1'))
               .gesture(
                  PanGesture({ direction: PanDirection.Right, distance: 5 }).onActionEnd(() => {

                  })
               )

               TabContent() {
                  Column() {
                     Text('SubTab 2')
                  }
                  .width('100%')
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundColor('#ff8c88b3')
               }.tabBar(this.subTabBuilder(1, 'SubTab 2'))

               TabContent() {
                  Column() {
                     Text('SubTab 3')
                  }
                  .width('100%')
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundColor('#ffb38888')
               }.tabBar(this.subTabBuilder(2, 'SubTab 3'))

               TabContent() {
                  Column() {
                     Text('SubTab 4')
                  }
                  .width('100%')
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundColor('#ffc19e7c')
               }.tabBar(this.subTabBuilder(3, 'SubTab 4'))

               TabContent() {
                  Column() {
                     Text('SubTab 5')
                  }
                  .width('100%')
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundColor('#ff7faaca')
               }.tabBar(this.subTabBuilder(4, 'SubTab 5'))

               TabContent() {
                  Column() {
                     Text('SubTab 6')
                  }
                  .width('100%')
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundColor('#ffb0b388')
               }.tabBar(this.subTabBuilder(5, 'SubTab 6'))
               .gesture(
                  PanGesture(this.panOption).onActionEnd(() => {
                     this.controller.changeIndex(1)
                  })
               )

            }
            .vertical(false)
            .scrollable(true)
            .barMode(BarMode.Scrollable, { margin: 40 })
            .barHeight(56)
            .barWidth('100%')
            .animationDuration(250)
            .onChange((index: number) => {
               // currentIndex控制TabContent显示页签
               // animateTo({ duration: 100 }, () => {
               this.currentSubIndex = index
               // })
            })
            .width('100%')
            .height('100%')
            .backgroundColor('#F1F3F5')

            // .fadingEdge(false) //default true

         }.tabBar(this.tabBuilder(0, 'Tab 1'))

         TabContent() {
            Music()
         }.tabBar(this.tabBuilder(1, 'Tab 2'))

      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      .barWidth('100%')
      .barHeight(50)
      .animationDuration(250)
      .onChange((index: number) => {
         hilog.debug(0, TAG, 'onChange: ' + index)
         // currentIndex控制TabContent显示页签
         // animateTo({ duration: 300 }, () => {
         this.currentIndex = index
         this.controller.changeIndex(index)
         // })
      })
      // .onAnimationStart((index,targetIdx) => {
      //   hilog.debug(0, TAG, 'onAnimationStart ' + this.currentIndex + '  ' + targetIdx)
      // animateTo({ duration: 300 }, () => {
      //   this.currentIndex = targetIdx
      // })
      // })
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
   }
}