import { hilog } from "@kit.PerformanceAnalysisKit"

let TAG = 'OtherDemos: gqz->'

@Preview
@Component
export struct FontSize {
   titleSize1: string = '10fp'
   titleSize2: string = '10fp'
   quoteSize: string = '10fp'
   fontSize: string = '10fp'

   build() {
      Column() {
         Text('标题1 Title1 123').fontSize(this.titleSize1).fontColor('#222')
         Divider()
            .height(1)
            .color('#999')
            .width('100%')
            .padding({
               top: 10,
               bottom: 10,
               left: 5,
               right: 5
            })
         Text('标题2 Title2 123').fontSize(this.titleSize2).fontColor('#222')
         Text('引用 Quote 123 引用 Quote 123 引用 Quote 123')
            .fontSize(this.quoteSize)
            .fontColor('#999')
            .margin({ top: 5 })
         Text('正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123')
            .fontSize(this.fontSize)
            .fontColor('#333')
            .margin({ top: 10 })
      }.alignItems(HorizontalAlign.Start)
      .border({ width: 1, color: '#aaa' })
      .padding(10)
   }
}


@Entry
@Component
export struct OtherDemos {
   aboutToAppear(): void {

   }

   build() {
      Scroll() {
         Column({ space: 20 }) {
            Text('自定义尺寸').fontSize(20).fontColor('#222')
            Divider()
               .height(1)
               .color('#999')
               .width('100%')
               .padding({
                  top: 10,
                  bottom: 10,
               })
            FontSize({
               titleSize1: '18fp',
               titleSize2: '14fp',
               quoteSize: '10fp',
               fontSize: '12fp'
            })
            FontSize({
               titleSize1: '22fp',
               titleSize2: '18fp',
               quoteSize: '13fp',
               fontSize: '15fp'
            })
            FontSize({
               titleSize1: '26fp',
               titleSize2: '20fp',
               quoteSize: '15fp',
               fontSize: '17fp'
            })

            Text('鸿蒙尺寸').fontSize(20).fontColor('#222')
            Divider()
               .height(1)
               .color('#999')
               .width('100%')
               .padding({
                  top: 10,
                  bottom: 10,
               })
            FontSize({
               titleSize1: '20fp',
               titleSize2: '14fp',
               quoteSize: '8fp',
               fontSize: '12fp'
            })
            FontSize({
               titleSize1: '24fp',
               titleSize2: '16fp',
               quoteSize: '10fp',
               fontSize: '14fp'
            })
            FontSize({
               titleSize1: '30fp',
               titleSize2: '18fp',
               quoteSize: '12fp',
               fontSize: '16fp'
            })

            //
            Row() {
               Text()
                  .layoutWeight(1)
                  .height(50)
                  .backgroundColor('black')
                  .borderWidth(1)
                  .borderColor('#ffde663d')
               Text()
                  .layoutWeight(1)
                  .height(50)
                  .backgroundColor('white')
                  .borderWidth(1)
                  .borderColor('#ffde663d')
               Text()
                  .layoutWeight(1)
                  .height(50)
                  .backgroundColor('gray')
                  .borderWidth(1)
                  .borderColor('#ffde663d')
            }

            Row() {
               Text()
                  .layoutWeight(1)
                  .height(50)
                  .backgroundColor('red')
                  .borderWidth(1)
                  .borderColor('#ffde663d')
               Text()
                  .layoutWeight(1)
                  .height(50)
                  .backgroundColor('green')
                  .borderWidth(1)
                  .borderColor('#ffde663d')
               Text()
                  .layoutWeight(1)
                  .height(50)
                  .backgroundColor('blue')
                  .borderWidth(1)
                  .borderColor('#ffde663d')
            }

            Row() {
               Row().height(50).backgroundColor('gray').layoutWeight(1)
               Row().height(50).backgroundColor('blue').width(50)
            }
         }
      }.scrollable(ScrollDirection.Vertical)
   }
}

