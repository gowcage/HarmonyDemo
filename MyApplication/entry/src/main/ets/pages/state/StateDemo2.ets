import { StateComp2 } from './pages/StateComp2'
import hilog from '@ohos.hilog'
import { StateComp1 } from './pages/StateComp1'
import { ObservedArray } from '../tabs/dropdowntabs/CustomTabContents'

@Observed
export class Item {
   name: string = ''
   age: number = 0
   friends: ObservedArray<string> = new ObservedArray()

   constructor(name: string, age: number) {
      this.name = name
      this.age = age
   }
}

@Component
struct View1 {
   @ObjectLink it: Item

   build() {
      Row({ space: 12 }) {
         Text(this.it.name)
         Text(this.it.age.toString()).margin({ top: 20 })
         Text(JSON.stringify(this.it.friends)).margin({ top: 20 })
      }.width('100%')
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
         this.it.friends.push('new friend ' + Math.round(Math.random() * 100))
         this.it.age++
      })
   }
}

@Entry
@Component
struct StateDemo2 {
   TAG = 'StateDemo2: hiby->'
   arr: string[] = ['a', 'b', 'c']
   @StorageLink('items') @Watch('onchanged') items: ObservedArray<Item> = new ObservedArray()

   onchanged(newValue: string) {
      hilog.debug(0, this.TAG, 'onchanged:' + newValue)
   }

   aboutToAppear(): void {
      StateComp2.setAge(28)
      StateComp2.setWeight(180)
      StateComp2.setUname('gqz')
      StateComp2.setPwd('123456')
      let a: number = StateComp2.getAge()
      let b: number = StateComp2.getWeight()
      let c: string = StateComp2.getUname()
      let d: string = StateComp2.getPwd()
      hilog.debug(0, this.TAG, 'aboutToAppear: ' + a + ',' + b + ',' + c + ',' + d)

      // 传递数组引用
      StateComp2.changeArr(this.arr)
      hilog.debug(0, this.TAG, 'aboutToAppear: ' + this.arr.toString())

      //    对象数组的状态观察
      this.items = new ObservedArray(
         new Item('gqz', 18),
         new Item('cage', 28),
         new Item('yk', 38),
      )
   }

   build() {
      Column() {
         Text(StateComp2.getUname())
         StateComp1()
         List() {
            ForEach(this.items, (item: Item, index: number) => {
               ListItem() {
                  // View1({ it: item })
                  Row({ space: 12 }) {
                     Text(item.name)
                     Text(item.age.toString()).margin({ top: 20 })
                     Text(JSON.stringify(item.friends)).margin({ top: 20 })
                  }.width('100%')
                  .alignItems(VerticalAlign.Center)
                  .onClick(() => {
                     // item.friends.push('new friend ' + Math.round(Math.random() * 100))
                     // item.age++
                     let it = this.items[index]
                     it.friends.push('new friend ' + Math.round(Math.random() * 100))
                     this.items[index] = new Item(it.name, it.age)
                     this.items[index].friends = it.friends
                  })
               }
            })
         }
      }
   }
}