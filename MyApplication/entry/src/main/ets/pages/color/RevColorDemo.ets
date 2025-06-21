/*
 * Created by Gqz (gaoqizhi@hiby.com) on 2025/6/21
 */
import hilog from "@ohos.hilog"

export interface RGB {
   r: number
   g: number
   b: number
}

@Entry
@Component
export struct RevColorDemo {
   private readonly TAG = 'RevColorDemo: ***'
   //
   private max: number = 500
   private baseVal = 1 / 1
   private clrArr: ColorStop[] = [
      { color: "rgb(0,0,0)", offset: 0 },
      // { color: "rgb(255,0,0)", offset: this.baseVal },
      // { color: "rgb(255,255,0)", offset: this.baseVal * 2 },
      // { color: "rgb(0,255,0)", offset: this.baseVal * 3 },
      // { color: "rgb(0,255,255)", offset: this.baseVal * 4 },
      // { color: "rgb(0,0,255)", offset: this.baseVal * 5 },
      // { color: "rgb(255,0,255)", offset: this.baseVal * 6 },
      // { color: "rgb(255,0,0)", offset: this.baseVal * 7 },
      { color: "rgb(255,255,255)", offset: 1 },
   ]
   @State value: number = 0
   @State colorGradient: LinearGradient = new LinearGradient(this.clrArr)
   @State color1: string = 'rgb(0,0,0)'
   @State color2: string = 'rgb(0,0,0)'
   @State txtClr1: string = 'rgb(0,0,0)'
   @State txtClr2: string = 'rgb(0,0,0)'

   resClr2RGB(clr: ResourceColor): RGB {
      let clrStr1 = clr as string
      let rgb = clrStr1.match(/\d+/g)
      if (rgb && rgb.length > 0) {
         return { r: Number(rgb[0]), g: Number(rgb[1]), b: Number(rgb[2]) }
      }
      return { r: 0, g: 0, b: 0 }
   }

   /*
    * ratio: 0 ~ 1
    * */
   getRGBBetween2Clr(clr1: ResourceColor, clr2: ResourceColor, ratio: number): RGB {
      let rgb1 = this.resClr2RGB(clr1)
      let rgb2 = this.resClr2RGB(clr2)
      return {
         r: Math.round((rgb2.r - rgb1.r) * ratio + rgb1.r),
         g: Math.round((rgb2.g - rgb1.g) * ratio + rgb1.g),
         b: Math.round((rgb2.b - rgb1.b) * ratio + rgb1.b),
      }
   }

   calcColor(clrArr: ColorStop[], curProgress: number, maxProgress: number, step: number): RGB {
      let clrs = clrArr
      let rVal = curProgress / maxProgress
      let idx = Math.floor(rVal / step)
      if (idx >= clrs.length - 1) {
         return { r: 255, g: 255, b: 255 }
      }
      let clr1: ResourceColor = clrs[idx]['color']
      let clr2: ResourceColor = clrs[idx + 1]['color']
      let ratio = (rVal - (clrs[idx]['offset'] as number)) /
         ((clrs[idx+1]['offset'] as number) - (clrs[idx]['offset'] as number))

      return this.getRGBBetween2Clr(clr1, clr2, ratio)
   }

   /*
    * ratio: 0 ~ 1
    * */
   revColor(clr: RGB): RGB {
      // 0 - 255
      // 0 - 100   ...  155 - 255
      // 0% - 50%       50% - 100%
      let srcR = clr.r
      let srcG = clr.g
      let srcB = clr.b
      let leftArea = 255 * .3
      let rightArea = 255 * .7
      let ratioR = srcR / 255
      let ratioG = srcG / 255
      let ratioB = srcB / 255

      return {
         r: ratioR > .5 ? Math.round(Math.min(leftArea, 255 - srcR)) :
         Math.round(Math.max(rightArea, 255 - srcR)),
         g: ratioG > .5 ? Math.round(Math.min(leftArea, 255 - srcG)) :
         Math.round(Math.max(rightArea, 255 - srcG)),
         b: ratioB > .5 ? Math.round(Math.min(leftArea, 255 - srcB)) :
         Math.round(Math.max(rightArea, 255 - srcB)),
      }

      // return {
      //    r: 255 - clr.r,
      //    g: 255 - clr.g,
      //    b: 255 - clr.b,
      // }
   }

   build() {
      Column() {
         Row({ space: 20 }) {
            Text('演示文本 ABC abc 1234')
               .fontColor(this.txtClr1)
               .backgroundColor(this.color1)
               .border({ width: 1, color: 'black' })
               .width(200)
               .height(50)
            Text('演示文本 ABC abc 1234')
               .fontColor(this.txtClr2)
               .backgroundColor(this.color2)
               .border({ width: 1, color: 'black' })
               .width(200)
               .height(50)
         }.width('100%').height(80)

         Slider({
            value: this.value,
            min: 0,
            max: this.max,
            direction: Axis.Horizontal,
         })
            .showSteps(true)
            .showTips(true)
            .width('100%')
            .trackColor(this.colorGradient)
            .trackThickness(8)
            .selectedColor(Color.Transparent)
            .onChange((value: number, mode: SliderChangeMode) => {
               this.value = value
               let clr = this.calcColor(this.clrArr, this.value, this.max, this.baseVal)
               this.color1 = `rgb(${clr.r},${clr.g},${clr.b})`
               let revClr = this.revColor(clr)
               this.color2 = `rgb(${revClr.r},${revClr.g},${revClr.b})`
               this.txtClr1 = this.color2
               this.txtClr2 = this.color1
               hilog.info(0, this.TAG,
                  'value: ' + value.toString() + ' color: ' + this.color1 + ' revColor: ' + this.color2)
            })
      }.width('100%').height('100%')
   }
}

