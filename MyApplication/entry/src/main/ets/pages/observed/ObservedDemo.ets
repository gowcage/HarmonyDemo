import { ObservedArray } from "../tabs/dropdowntabs/CustomTabContents"

@Entry
@Component
export struct ObservedDemo {
   @State cls: Cls = new Cls()
   @State arr: Cls[] = []
   @State oarr: ObservedArray<Cls> = new ObservedArray<Cls>()

   aboutToAppear(): void {
      let a = new Cls()
      let b = new Cls()
      let c = new Cls()

      this.arr.push(a, b, c)
      this.oarr.push(a, b, c)
   }

   build() {
      Column() {
         Text(`cls: {${this.cls.str} ${this.cls.num} ${this.cls.bool}}`)
         Button('change cls obj').onClick(() => {
            this.cls.str = 'str'
            this.cls.num = 5
            this.cls.bool = true
         })

         Blank().height(20)

         Text(`arr[0]: {${this.arr[0].str} ${this.arr[0].num} ${this.arr[0].bool}}`)
         Button('change arr[0] obj').onClick(() => {
            this.arr[0].str = 'cage'
            this.arr[0].num = 123
            this.arr[0].bool = true

            // 直接改变对象可以观测到
            // let a = new Cls()
            // a.str = 'cage'
            // a.num = 123
            // a.bool = true
            // this.arr[0] = a
         })

         Blank().height(20)

         Text(`oarr[0]: {${this.oarr[0].str} ${this.oarr[0].num} ${this.oarr[0].bool}}`)
         Button('change oarr[0] obj').onClick(() => {
            this.oarr[0].str = 'arr'
            this.oarr[0].num = 321
            this.oarr[0].bool = true

            // 直接改变对象可以观测到
            // let a = new Cls()
            // a.str = 'arr'
            // a.num = 321
            // a.bool = true
            // this.oarr[0] = a
         })
      }
   }
}

@Observed
export class Cls {
   @Track str: string = ''
   @Track num: number = 0
   @Track bool: boolean = false
}