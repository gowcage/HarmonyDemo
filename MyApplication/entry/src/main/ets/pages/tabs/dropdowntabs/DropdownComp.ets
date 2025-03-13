import { LengthMetrics } from '@kit.ArkUI'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { unifiedDataChannel, uniformTypeDescriptor } from '@kit.ArkData'
import { BusinessError } from '@kit.BasicServicesKit'
import { JSON } from '@kit.ArkTS'
import { ObservedArray } from './CustomTabContents'

@Preview
@Component
export struct DropdownComp {
   TAG = 'DropdownComp: gqz->'
   @Link tabContentNamesDisplayed: ObservedArray<string>
   @Link tabContentNamesBackup: ObservedArray<string> //作为备选项数据源
   @StorageLink('isDropdown') isDropdown: boolean = false
   @State private currentBp: string = 'unknown'
   @State private isPlayDragAnim: boolean = false
   @State private dragAnimRotate: number = 0
   @State private dragItemText: string = ''
   private uiContext: UIContext | undefined = undefined;

   aboutToAppear() {
      hilog.debug(0, this.TAG, 'aboutToAppear: tabContentNamesDisplayed:' + this.tabContentNamesDisplayed.toString())
      hilog.debug(0, this.TAG, 'aboutToAppear: tabContentNamesBackup:' + this.tabContentNamesBackup.toString())
      this.uiContext = this.getUIContext?.();
   }

   getDataFromUdmfRetry(event: DragEvent, callback: (data: DragEvent) => void) {
      try {
         let data: UnifiedData = event.getData();
         if (!data) {
            return false;
         }
         let records: Array<unifiedDataChannel.UnifiedRecord> = data.getRecords();
         if (!records || records.length <= 0) {
            return false;
         }
         callback(event);
         return true;
      } catch (e) {
         console.log("getData failed, code = " + (e as BusinessError).code + ", message = " +
         (e as BusinessError).message);
         return false;
      }
   }

   getDataFromUdmf(event: DragEvent, callback: (data: DragEvent) => void) {
      if (this.getDataFromUdmfRetry(event, callback)) {
         return;
      }
      setTimeout(() => {
         this.getDataFromUdmfRetry(event, callback);
      }, 1500);
   }

   @Builder
   dragPreviewBuilder() {
      // Column() {
      Text(this.dragItemText)
         .width(120)
         .height(40)
         .fontSize(16)
         .border({ width: 1, color: Color.Black, radius: 20 })
         .backgroundColor('#aeee')
         .textAlign(TextAlign.Center)
         .fontColor(Color.Black)
      // }
   }

   build() {
      Column() {
         Text('分类排序')
            .fontSize(LengthMetrics.fp(16).value)
            .fontColor('#333')
            .width('100%')
            .height(50)
            .backgroundColor('white')
            .padding({ left: 20 })
            .onClick(() => {
               animateTo({ duration: 200 }, () => {
                  this.isDropdown = false
               })
            })

         GridRow({
            columns: 4,
            gutter: { x: 15, y: 15 },
            breakpoints: {
               value: ["400vp", "600vp", "800vp"],
               reference: BreakpointsReference.WindowSize
            },
            direction: GridRowDirection.Row
         }) {
            ForEach(this.tabContentNamesDisplayed, (item: string, index: number) => {
               GridCol({
                  span: {
                     xs: 1,
                     sm: 2,
                     md: 3,
                     lg: 4
                  },
                  offset: 0,
                  order: 0
               }) {
                  Text(item)
                     .fontColor('black')
                     .fontSize(14)
                     .textAlign(TextAlign.Center)
                     .width('100%')
                     .height(30)
                     .border({ color: 'gray', width: 1, radius: 20 })
                     .draggable(true)
                     .rotate({
                        z: 1,
                        angle: this.dragAnimRotate,
                        centerX: '50%',
                        centerY: '50%'
                     })
                     .onPreDrag(() => {
                        this.dragItemText = item
                     })
                     .onDragStart((event: DragEvent) => {
                        let data: unifiedDataChannel.PlainText = new unifiedDataChannel.PlainText()
                        data.abstract = index + ''
                        data.textContent = item
                        event.setData(new unifiedDataChannel.UnifiedData(data))

                        this.isPlayDragAnim = true
                        this.uiContext?.keyframeAnimateTo({ iterations: -1 }, [
                           {
                              duration: 100, event: () => {
                              this.dragAnimRotate = 5
                           }
                           },
                           {
                              duration: 100, event: () => {
                              this.dragAnimRotate = -5
                           }
                           }
                        ])
                     })
                     .onDragEnd((event: DragEvent) => {
                        this.isPlayDragAnim = false
                        animateTo({ duration: 0 }, () => {
                           this.dragAnimRotate = 0
                        })
                     })// 自定义拖拽的预览效果
                     .dragPreview(this.dragPreviewBuilder)
                     .onClick(() => {
                        this.tabContentNamesBackup.push(this.tabContentNamesDisplayed[index])
                        this.tabContentNamesDisplayed.splice(index, 1)
                     })
               }
               .allowDrop([uniformTypeDescriptor.UniformDataType.PLAIN_TEXT])
               .onDrop((dragEvent?: DragEvent) => {
                  this.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
                     let records: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords();
                     let data: unifiedDataChannel.PlainText = records[0] as unifiedDataChannel.PlainText;
                     hilog.debug(0, this.TAG,
                        'onDrop: ' + JSON.stringify(event) + "  text:" + data.textContent + '  index:' +
                        data.abstract)
                     let tmp = item
                     this.tabContentNamesDisplayed[index] = data.textContent
                     this.tabContentNamesDisplayed[Number.parseInt(data.abstract as string)] = tmp
                  })
               })
            })
         }.width("100%").height("25%")
         .onBreakpointChange((breakpoint) => {
            this.currentBp = breakpoint
         })
         .padding({
            top: 20,
            bottom: 20,
            left: 10,
            right: 10
         })

         //

         Text('添加分类')
            .fontSize(LengthMetrics.fp(16).value)
            .fontColor('#333')
            .width('100%')
            .height(50)
            .backgroundColor('white')
            .padding({ left: 20 })

         GridRow({
            columns: 4,
            gutter: { x: 15, y: 15 },
            breakpoints: {
               value: ["400vp", "600vp", "800vp"],
               reference: BreakpointsReference.WindowSize
            },
            direction: GridRowDirection.Row
         }) {
            ForEach(this.tabContentNamesBackup, (item: string, index: number) => {
               GridCol({
                  span: {
                     xs: 1,
                     sm: 2,
                     md: 3,
                     lg: 4
                  },
                  offset: 0,
                  order: 0
               }) {
                  Text(item)
                     .fontColor('black')
                     .fontSize(14)
                     .textAlign(TextAlign.Center)
                     .width('100%')
                     .height(30)
                     .border({ color: 'gray', width: 1, radius: 20 })
                     .onClick(() => {
                        this.tabContentNamesDisplayed.push(this.tabContentNamesBackup[index])
                        this.tabContentNamesBackup.splice(index, 1)
                     })
               }
            })
         }.width("100%").layoutWeight(1)
         .onBreakpointChange((breakpoint) => {
            this.currentBp = breakpoint
         })
         .padding({
            top: 20,
            bottom: 20,
            left: 10,
            right: 10
         })

         Image($rawfile('icon/close.png'))
            .width(40)
            .height(40)
            .borderRadius(40)
            .backgroundColor('#1000')
            .position({ x: '45%', y: '90%' })
            .onClick(() => {
               animateTo({ duration: 200 }, () => {
                  this.isDropdown = false
               })
            })
      }
      .width('100%').height('100%')
      .backgroundColor('#eee')
   }
}