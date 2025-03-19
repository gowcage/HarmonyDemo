import hilog from '@ohos.hilog'

let TAG = 'RingSliderDemo: gqz->'

@Entry
@Component
struct RingSliderDemo {
   @State @Watch('onVarChanged') private value: number = 0
   @State private max: number = 100
   @State private offX: number = 0
   @State private offY: number = 0
   @State ringSliderRadius: number = 100
   private ringSliderDiameter: number = this.ringSliderRadius * 2

   aboutToAppear(): void {
      this.offY = -100
   }

   typeStr(type: TouchType): string {
      switch (type) {
         case TouchType.Down:
            return 'Down'
         case TouchType.Up:
            return 'Up'
         case TouchType.Move:
            return 'Move'
         case TouchType.Cancel:
            return 'Cancel'
      }
      return type.toString()
   }

   onVarChanged(name: string) {
      switch (name) {
         case 'value': {
            let deg = this.value * 3.6
            let arc = deg * Math.PI / 180
            let x = Math.sin(arc)
            let y = Math.cos(arc) * -1
            /*
             * 对齐Thumb和progress
             * 用progress半径减去 (progress strokeWidth/2 + (Thumb.width-1)/2)
             * Thumb.width为奇数最佳
             * */
            this.offX = x * (this.ringSliderRadius - 4)
            this.offY = y * (this.ringSliderRadius - 4)
         }
      }
   }

   build() {
      Column() {
         Stack() {
            Progress({ value: this.value, total: this.max, type: ProgressType.Ring })
               .width(this.ringSliderDiameter)
               .height(this.ringSliderDiameter)// .color('#ff0996bc')
               .color(new LinearGradient([{ offset: 0, color: '#ff87bee2' }, { offset: 1, color: '#ff1394e7' }]))
               .backgroundColor('#66aaaaaa')
               .style({ strokeWidth: 2, shadow: true })

            Text()
               .width(this.ringSliderDiameter)
               .height(this.ringSliderDiameter)
               .backgroundColor('#22ff0000')
               .borderRadius(this.ringSliderDiameter)
               .onClick(() => {
                  hilog.debug(0, TAG, 'onClick...')
               })
               .onTouch((event: TouchEvent) => {
                  let touch = event.touches[0]
                  let x = touch.x
                  let y = touch.y
                  let cx = (x - this.ringSliderRadius) * -1 // * -1 将起始0°对调到左边，并转为顺时针方向
                  let cy = (y - this.ringSliderRadius) * -1 // * -1 将Y轴对调，因为系统的Y轴与数学坐标系Y轴相反
                  let arc = Math.atan2(cy, cx)
                  let deg = arc * 180 / Math.PI - 90 // -90 上面调整后，progress组件的0在正上方，touch的0位置在正左边
                  deg = deg < 0 ? deg + 360 : deg
                  if (event.type == TouchType.Up) {
                     hilog.debug(0, TAG,
                        'onTouch: ' + this.typeStr(event.type) + '  ' + cx + '/' + cy + '  arc=' + arc + '  deg=' + deg)
                  } else {
                     hilog.debug(0, TAG,
                        'onTouch: ' + '  deg=' + deg)
                  }
                  this.value = deg / 360 * this.max
               })

            // Progress Thumb
            Text()
               .backgroundColor('#fff')
               .width(7)
               .height(7)
               .borderRadius(7)
               .shadow({ color: 'black', radius: 7 })
               .offset({ x: this.offX, y: this.offY })
         }
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .height('100%')
      .width('100%')
   }
}