import { unifiedDataChannel, uniformTypeDescriptor } from '@kit.ArkData';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

// import { UIContext } from '@kit.ArkUI';

@Preview
@Entry
@Component
export struct DragDemo {
   TAG = 'DragDemo: ->'
   @State targetImage: string = '';
   @State targetText: string = 'Drag Text';
   @State imageWidth: number = 100;
   @State imageHeight: number = 100;
   @State imgState: Visibility = Visibility.Visible;
   @State abstractContent: string = "abstract";
   @State textContent: string = "";
   @State backGroundColor: Color = Color.Transparent;
   private uiContext: UIContext | undefined = undefined;
   @State private r_size: number = 100

   aboutToAppear() {
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

   build() {
      Row() {
         Column() {
            Text('start Drag')
               .fontSize(18)
               .width('100%')
               .height(40)
               .margin(10)
               .backgroundColor('#008888')

            Image($r('app.media.startIcon'))
               .width(100)
               .height(100)
               .draggable(true)
               .margin({ left: 15 })
               .visibility(this.imgState)
               .onDragEnd((event) => {
                  // onDragEnd里取到的result值在接收方onDrop设置
                  if (event.getResult() === DragResult.DRAG_SUCCESSFUL) {
                     promptAction.showToast({ duration: 100, message: 'Drag Success' });
                  } else if (event.getResult() === DragResult.DRAG_FAILED) {
                     promptAction.showToast({ duration: 100, message: 'Drag failed' });
                  }
               })

            Column() {
               Text('this is abstract')
                  .fontSize(20)
                  .width('100%')
            }
            .margin({ left: 40, top: 20 })
            .width('100%')
            .height(100)
            .onDragStart((event) => {
               this.backGroundColor = Color.Transparent;
               let data: unifiedDataChannel.PlainText = new unifiedDataChannel.PlainText();
               data.abstract = 'this is abstract';
               data.textContent = 'this is content this is content';
               (event as DragEvent).setData(new unifiedDataChannel.UnifiedData(data));
            })
            .onPreDrag((status: PreDragStatus) => {
               if (status == PreDragStatus.READY_TO_TRIGGER_DRAG_ACTION) {
                  this.backGroundColor = Color.Red;
               } else if (status == PreDragStatus.ACTION_CANCELED_BEFORE_DRAG
                  || status == PreDragStatus.PREVIEW_LANDING_FINISHED) {
                  this.backGroundColor = Color.Blue;
               }
            })
            .backgroundColor(this.backGroundColor)

         }.width('45%')
         .height('100%')

         // 接收

         Column() {
            Text('Drag Target Area')
               .fontSize(20)
               .width('100%')
               .height(40)
               .margin(10)
               .backgroundColor('#008888')

            Image(this.targetImage)
               .width(this.imageWidth)
               .height(this.imageHeight)
               .draggable(true)
               .margin({ left: 15 })
               .border({ color: Color.Black, width: 1 })
               .allowDrop([uniformTypeDescriptor.UniformDataType.IMAGE])
               .onDrop((dragEvent?: DragEvent) => {
                  this.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
                     let records: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords();
                     let rect: Rectangle = event.getPreviewRect();
                     this.imageWidth = Number(rect.width);
                     this.imageHeight = Number(rect.height);
                     this.targetImage = (records[0] as unifiedDataChannel.Image).imageUri;
                     event.useCustomDropAnimation = false;
                     this.imgState = Visibility.None;
                     // 显式设置result为successful，则将该值传递给拖出方的onDragEnd
                     event.setResult(DragResult.DRAG_SUCCESSFUL);
                  })
               })

            Text(this.targetText)
               .width('100%')
               .height(100)
               .border({ color: Color.Black, width: 1 })
               .margin(15)
               .allowDrop([uniformTypeDescriptor.UniformDataType.PLAIN_TEXT])
               .onDrop((dragEvent?: DragEvent) => {
                  this.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
                     let records: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords();
                     let plainText: unifiedDataChannel.PlainText = records[0] as unifiedDataChannel.PlainText;
                     this.targetText = plainText.textContent;
                  })
               })

            Column() {
               Text(this.abstractContent).fontSize(20).width('100%')
               Text(this.textContent).fontSize(15).width('100%')
            }
            .width('100%')
            .height(100)
            .margin(20)
            .border({ color: Color.Black, width: 1 })
            .allowDrop([uniformTypeDescriptor.UniformDataType.PLAIN_TEXT])
            .onDrop((dragEvent?: DragEvent) => {
               this.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
                  let records: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords();
                  let plainText: unifiedDataChannel.PlainText = records[0] as unifiedDataChannel.PlainText;
                  this.abstractContent = plainText.abstract as string;
                  this.textContent = plainText.textContent;
               })
            })
         }.width('45%')
         .height('100%')
         .margin({ left: '5%' })
      }
      .height('100%')
   }
}