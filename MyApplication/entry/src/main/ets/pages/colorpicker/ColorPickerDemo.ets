import hilog from "@ohos.hilog";

interface BlockConfig {
   left: number;
   top: number;
}

@Entry
@Component
export struct ColorPickerDemo {
   TAG = 'hiby: ColorPickerDemo'
   //
   _width: number = 200
   _height: number = 200
   @State private topCanvasHeight: number = 0
   @State private x1: number = 0
   @State private y1: number = 0
   @State private block: BlockConfig = {
      left: 0,
      top: 0
   }
   @State private startX: number = 0
   @State private startY: number = 0
   @State private maxHeight: number = 200
   // 获取主色系rgb的数组
   @State private rgb: number[] = [255, 0, 0]
   // color是主要的rgb值存储，它将和colorValue的16进制的值相对于
   @State private color: number[] = [255, 0, 0]
   @State private slctClr: string = '#f00'
   @State block2: number = 0.05
   //
   private settings1: RenderingContextSettings = new RenderingContextSettings(true)
   private settings2: RenderingContextSettings = new RenderingContextSettings(true)
   private ctx1: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings1)
   private ctx2: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings2)
   private gradient: CanvasGradient = new CanvasGradient()
   private gradient2: CanvasGradient = new CanvasGradient()
   // 色系
   private colors = [
      [255, 0, 0],
      [255, 255, 0],
      [0, 255, 0],
      [0, 255, 255],
      [0, 0, 255],
      [255, 0, 255],
      [255, 0, 0]
   ]

   aboutToAppear(): void {
      this.topCanvasHeight = this._height
      this.gradient = this.ctx1.createLinearGradient(0, 0, this._width, 0)
      this.gradient.addColorStop(0, '#ffff')
      this.gradient.addColorStop(1, this.slctClr) // todo: this color need to be a state variable

      this.gradient2 = this.ctx1.createLinearGradient(0, this.topCanvasHeight, 0, 0)
      this.gradient2.addColorStop(0, '#f000')
      this.gradient2.addColorStop(1, '#0000')
   }

   // getColor(ctx: CanvasRenderingContext2D, x: number, y: number): string {
   //    let imgData = ctx.getImageData(x, y, 1, 1)
   //    let data = imgData.data
   //    let clr = '#' + ('00000' + (data[0] << 16 | data[1] << 8 | data[2]).toString(16)).slice(-6);
   //    return clr
   // }

   draw1() {
      // this.ctx1.clearRect(0,0,this._width, this.topCanvasHeight)
      // this.ctx1.reset()
      // draw color panel
      this.ctx1.fillStyle = this.gradient
      this.ctx1.fillRect(0, 0, this._width, this.topCanvasHeight)
      this.ctx1.fillStyle = this.gradient2
      this.ctx1.fillRect(0, 0, this._width, this.topCanvasHeight)
   }

   getColor2() {
      let right = [255, 0, 0]
      let left = [255, 255, 255]
      let bottom = [0, 0, 0]
      let ratio = this.block.left / this.ctx1.width
      let vratio = this.block.top / this.ctx1.height

      this.color = this.rgb.map((p: number) => {
         let x = Math.round(255 * (1 - ratio) + p * ratio)
         return x * (1 - vratio)
      })
      // this.color = [left[0] * (1 - ratio) + right[0] * ratio, left[1] * (1 - ratio) + right[1] * ratio,
      //    left[2] * (1 - ratio) + right[2] * ratio]
      // this.color = [this.color[0] * (1 - vratio), this.color[1] * (1 - vratio), this.color[2] * (1 - vratio)]
      hilog.debug(0, this.TAG, 'getColor2():  color: ' + this.color + '  rgb:' + this.colorRGBtoHex())
      this.slctClr = this.colorRGBtoHex()
   }

   getMainColor(ratio: number) {
      // get left and right color from this.colors by ratio
      let leftClr = this.colors[0]
      let rightClr = this.colors[1]
      let startRatio = 0
      for (let i = 0; i < this.colors.length - 1; i++) {
         let p: number[] = this.colors[i]
         if (i == this.colors.length - 1) {
            leftClr = p
            rightClr = p
            break
         }
         startRatio = i / (this.colors.length - 1)
         let endRatio = (i + 1) / (this.colors.length - 1)
         // hilog.debug(0, TAG, 'l_ratio=' + startRatio + '  r_ratio=' + endRatio)
         if (startRatio <= ratio && ratio < endRatio) {
            leftClr = p
            rightClr = this.colors[i + 1]
            break
         }
      }
      this.rgb = this.getColorBetween2Color(ratio - startRatio, leftClr, rightClr)
      this.getColor2()
      this.draw1()
      // hilog.debug(0, TAG, 'ratio=' + ratio + '  startRatio=' + startRatio)
   }

   getColorBetween2Color(ratio: number, leftClr: number[], rightClr: number[]): number[] {
      return leftClr.map((p: number, i: number) => {
         return Math.round(p * (1 - ratio) + rightClr[i] * ratio)
      })
   }

   /**
    * 修改颜色，主色为右上角{ x: width, y: 0 }位置
    * 选择颜色，先根据x轴离左侧边缘相对于宽度的比例，根据这个比例获取，rgb每个值与255的差值计算得到第一个数值
    * 再根据这个数值到0，获得垂直比例数值，得到这个数值
    * 最后使用
    */
   getColor() {
      const width = this.ctx1.width
      const height = this.maxHeight
      this.color = this.rgb.map((p: number) => {
         // 计算公式
         const xNum = p + (255 - p) * (width - this.block.left) / width
         return Math.round(xNum - xNum * this.block.top / height)
      })
      // this.$colorValue(this.colorRGBtoHex())
      hilog.debug(0, this.TAG, 'color: ' + this.color + '  rgb:' + this.colorRGBtoHex())
      this.slctClr = this.colorRGBtoHex()
   }

   // rgb转16进制
   colorRGBtoHex(): string {
      const rgb = this.color.map(p => p.toString())
      const r = parseInt(rgb[0]);
      const g = parseInt(rgb[1]);
      const b = parseInt(rgb[2]);
      const hex = "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
      return hex;
   }

   build() {
      Column({ space: 20 }) {
         Button().backgroundColor(this.slctClr)
            .border({ width: .5, color: 'black' })

         // color picker 1
         Stack() {
            Canvas(this.ctx1)
               .width(this._width)
               .height(this.topCanvasHeight)
               .border({ radius: 12, width: .5, color: '#f00' })
               .clip(true)
               .onReady(() => {
                  this.draw1()
               })

            // Canvas(this.ctx2)
            //    .width(this._width)
            //    .height(this.topCanvasHeight)
            //    .border({ radius: 12, width: .5, color: '#f00' })
            //    .clip(true)
            //    .onReady(() => {
            //       this.draw2()
            //    })
            /*.onTouch((e) => {
               switch (e.type) {
                  case TouchType.Down:
                     this.x1 = e.touches[0].x
                     this.y1 = e.touches[0].y
                     this.slctClr = this.getColor(this.ctx1, this.x1, this.y1)
                     this.draw2()
                     break
                  case TouchType.Move:
                     this.x1 = e.touches[0].x
                     this.y1 = e.touches[0].y
                     this.slctClr = this.getColor(this.ctx1, this.x1, this.y1)
                     this.draw2()
                     break
                  case TouchType.Up:
                     this.x1 = e.touches[0].x
                     this.y1 = e.touches[0].y
                     this.slctClr = this.getColor(this.ctx1, this.x1, this.y1)
                     this.draw2()
                     break
               }
            })*/
            Row()
               .width(15)
               .height(15)
               .shadow({ radius: 10, color: Color.Gray })
               .border({
                  width: 2,
                  color: 'white',
                  radius: 15,
                  style: BorderStyle.Solid
               })
               .position({ x: this.block.left, y: this.block.top })
               .markAnchor({ x: 8, y: 8 })
            // .onTouch((event) => {
            //    event.stopPropagation()
            //    const touches = event.touches[0];
            //    if (event.type == TouchType.Move) {
            //       const x = touches.x + this.startX;
            //       const y = touches.y + this.startY;
            //       const width = this.ctx1.width
            //       const height = this.maxHeight
            //       this.block = {
            //          left: x < 0 ? 0 : x > width ? width : x,
            //          top: y < 0 ? 0 : y > height ? height : y,
            //       }
            //       this.getColor()
            //    } else if (event.type == TouchType.Up) {
            //       this.startX = this.block.left;
            //       this.startY = this.block.top;
            //    }
            // })
         }
         .onTouch((event) => {
            event.stopPropagation()
            const touches = event.touches[0];
            const width = this.ctx1.width
            const height = this.maxHeight
            const x = touches.x;
            const y = touches.y;
            if (event.type == TouchType.Down) {
               this.block = {
                  left: x < 0 ? 0 : x > width ? width : x,
                  top: y < 0 ? 0 : y > height ? height : y,
               }
               // this.getColor()
               this.getColor2()
            } else if (event.type == TouchType.Move) {
               this.block = {
                  left: x < 0 ? 0 : x > width ? width : x,
                  top: y < 0 ? 0 : y > height ? height : y,
               }
               // this.getColor()
               this.getColor2()
            } else if (event.type == TouchType.Up) {
               this.startX = this.block.left;
               this.startY = this.block.top;
            }
         })

         // color picker 2
         Row() {
            Row()
               .width(16)
               .height(16)
               .backgroundColor('white')
               .borderRadius(16)
               .shadow({ radius: 10, color: Color.Gray })
               .position({ x: this.block2 * this._width, y: 0 })
               .markAnchor({ x: 8, y: -2 })
         }
         .width(200)
         .height(20)
         .border({ radius: 10 })
         .linearGradient({
            angle: 90,
            colors: this.colors.map((p: number[], i: number) => [`rgb(${p.join()})`, i / (this.colors.length - 1)])
         })
         .onTouch((event) => {
            const touches = event.touches[0];
            this.block2 = Math.max(0.05, Math.min(touches.x / this._width, .95))
            if (event.type == TouchType.Down) {
               this.getMainColor(touches.x / this._width)
            } else if (event.type == TouchType.Move) {
               this.getMainColor(touches.x / this._width)
            } else if (event.type == TouchType.Up) {
            }
         })

         Row() {
            Button('save').onClick(() => {
               // this.ctx1.save()
               this.ctx1.clearRect(0, 0, this._width, this.topCanvasHeight)
            })
            Button('restore').onClick(() => {
               // this.ctx1.restore()
               this.ctx1.reset()
            })
            Button('draw').onClick(() => {
               this.ctx1.fillRect(this.x1, this.y1, 10, 10)
            })
         }
      }
      .alignItems(HorizontalAlign.Center)
   }
}