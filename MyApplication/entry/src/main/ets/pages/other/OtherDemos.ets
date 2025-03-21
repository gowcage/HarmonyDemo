import { hilog } from "@kit.PerformanceAnalysisKit"

let TAG = 'OtherDemos: gqz->'


@Builder
function Bg(res: Resource, blur: BlurStyle) {
   Image(res)
      .width('100%')
      .height('100%')
      .objectFit(ImageFit.Contain)
      .backgroundBlurStyle(blur)
}

@Builder
function Txt(blur: number) {
   Text()
      .backgroundImage($r('app.media.bg'))
      .backgroundImageSize({width: 125,height:100})
      .width(125)
      .height(100)
      .border({ width: 1, color: 'black' })
      .blur(blur)
}

@Entry
@Component
struct OtherDemos {
   build() {
      Column({ space: 20 }) {
         Row() {
            Txt(0)
         }.width('100%')
         .justifyContent(FlexAlign.SpaceBetween)

         Row() {
            Txt(1)
            Txt(3)
            Txt(5)
         }.width('100%')
         .justifyContent(FlexAlign.SpaceBetween)

         Row() {
            Txt(10)
            Txt(20)
            Txt(30)
         }.width('100%')
         .justifyContent(FlexAlign.SpaceBetween)

         Row() {
            Txt(50)
            Txt(100)
            Txt(150)
         }.width('100%')
         .justifyContent(FlexAlign.SpaceBetween)

         Row() {
            Txt(300)
            Txt(600)
            Txt(900)
         }.width('100%')
         .justifyContent(FlexAlign.SpaceBetween)
      }
   }
}


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

@Component
struct A {
   build() {
      Row() {
         Image($r('app.media.startIcon')).width(40).height(40)
         Column() {
            Text('11111111')
            Text('22222222')
         }

         Image($r('app.media.startIcon')).width(40).height(40)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
   }
}

@Component
struct B {
   build() {
      Column() {
         Image($r('app.media.startIcon')).width(150).height(150).margin({ top: 30, bottom: 30 })
         C()
         D()
         E()
      }
      .width('100%')
      .layoutWeight(1)
      .border({ width: 2, color: 'green' })
   }
}

@Component
struct C {
   build() {
      Row() {
         Image($r('app.media.startIcon')).width(40).height(40)
         Image($r('app.media.startIcon')).width(40).height(40)
         Image($r('app.media.startIcon')).width(40).height(40)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .margin({ top: 30 })
   }
}

@Component
struct D {
   build() {
      Row() {
         Image($r('app.media.startIcon')).width(40).height(40)
         Row() {
            Text('11111111')
            Divider().vertical(true).strokeWidth(2).height(20).color('white')
            Text('22222222')
            Divider().vertical(true).strokeWidth(2).height(20).color('white')
            Text('33333333')
         }

         Image($r('app.media.startIcon')).width(40).height(40)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .margin({ top: 30, bottom: 30 })
   }
}

@Component
struct E {
   build() {
      Row() {
         Image($r('app.media.startIcon')).width(36).height(36)
         Image($r('app.media.startIcon')).width(42).height(42)
         Image($r('app.media.startIcon')).width(36).height(36)
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .layoutWeight(1)
   }
}


/*@Entry
@Component
export struct OtherDemos {
   build() {
      Column() {
         Row() {
            Button()
            Button()
            Button()
         }

         Row() {
            Text('11111111').onClick(() => {
               hilog.debug(0, TAG, 'onClick...')
            }).onTouch((event: TouchEvent) => {
               hilog.debug(0, TAG, 'onTouch...')
            })
            Text('22222222')
         }.justifyContent(FlexAlign.SpaceBetween)
         .width('100%')

         Divider().strokeWidth(2).color('black').margin({ top: 20, bottom: 20 })

         A()

         B()
      }
      .width('100%')
      .height('100%')
      .border({ width: 3, color: 'black' })
   }
}*/


/*@Entry
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
}*/

