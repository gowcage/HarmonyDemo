import { ObservedArray } from '../tabs/dropdowntabs/CustomTabContents'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { MixedType, MyNodeController } from '../tabs/dropdowntabs/MyNodeController'

let TAG = 'StateDemo: gqz->'

@Observed
class Parent {
   age: number = 0
   name: string = 'AB'
   child: ObservedArray<string> = new ObservedArray<string>('aa', 'bb', 'cc')
}

@Observed
class Child {
   age: number = 10
   name: string = 'gg'
   child: string[] = ['aa', 'bb', 'cc']
}

class Boy {
   @Track age: number = 10
   @Track name: string = 'gg'
   @Track friends: ObservedArray<string> = new ObservedArray<string>('aa', 'bb', 'cc')
}

@Builder
function testbuilder(p: MixedType) {
   Column() {
      Button('  ').onClick(() => {
         if (p instanceof Parent) {
            let pp = p as Parent
            if (pp.name == 'Cage') {
               pp.child.push('0_0')
            }
            if (pp.age == 30) {
               pp.name = 'Cage'
            }
            pp.age = 30
            hilog.info(0x0001, TAG, 'testbuilder: ' + JSON.stringify(pp))

         } else if (p instanceof Child) {
            let pp = p as Child
            if (pp.name == 'XXX') {
               pp.child.push('0o0')
               // pp.child = [...pp.child, '0_0']
            } //直接修改原数组（如 push）不会触发更新，需通过替换整个数组（如 [...原数组, 新元素]）实现响应式变更
            if (pp.age == 18) {
               pp.name = 'XXX'
            }
            pp.age = 18
            hilog.info(0x0001, TAG, 'testbuilder2: ' + JSON.stringify(pp))

         } else if (p instanceof ObservedArray) {
            let pp = p as ObservedArray<string>
            pp.push('~_~')
            hilog.info(0x0001, TAG, 'testbuilder4: ' + JSON.stringify(pp))

         } else if (p instanceof Array) {
            let pp = p as ObservedArray<string>
            pp.push('T_T')
            hilog.info(0x0001, TAG, 'testbuilder5: ' + JSON.stringify(pp))

         } else {
            let pp = p as Boy
            if (pp.name == 'q_p') {
               pp.friends.push('0o0')
            }
            if (pp.age == 18) {
               pp.name = 'q_p'
            }
            pp.age = 18
            hilog.info(0x0001, TAG, 'testbuilder3: ' + JSON.stringify(pp))
         }
      })
   }
}

class OuterTabContentNodeCtrl2<T extends MixedType> extends MyNodeController {
   constructor(param: T) {
      super(wrapBuilder(testbuilder), param)
   }
}

@Component
struct TestComp {
   @ObjectLink parent: Parent
   @ObjectLink child: Child
   @State pArr: string[] = []
   @State cArr: string[] = []

   aboutToAppear(): void {
      hilog.info(0x0001, TAG, 'aboutToAppear: ' + JSON.stringify(this.parent))
      this.parent.age = 50
      hilog.info(0x0001, TAG, 'aboutToAppear: ' + JSON.stringify(this.parent))
      this.parent.name = 'CD'
      hilog.info(0x0001, TAG, 'aboutToAppear: ' + JSON.stringify(this.parent))
      this.parent.child.pop()
      hilog.info(0x0001, TAG, 'aboutToAppear: ' + JSON.stringify(this.parent))
      this.parent.child.push('dd', 'ee')
      hilog.info(0x0001, TAG, 'aboutToAppear: ' + JSON.stringify(this.parent))
   }

   build() {
      Column() {
         Text(JSON.stringify(this.parent)).width('100%').fontSize(16).fontColor('black')
         Text(JSON.stringify(this.child)).width('100%').fontSize(16).fontColor('black')
         Text(JSON.stringify(this.pArr)).width('100%').fontSize(16).fontColor('black')
         Text(JSON.stringify(this.cArr)).width('100%').fontSize(16).fontColor('black')
      }
   }
}

@Observed
class Book {
   name: string = ''

   constructor(name: string) {
      this.name = name
   }
}

@Observed
class Bag {
   size: number = 5
   book: Book

   constructor(size: number, book: Book) {
      this.size = size
      this.book = book
   }
}

@Component
struct TestComp2 {
   @ObjectLink bag: Bag
   @ObjectLink book: Book

   build() {
      Column() {
         Text(JSON.stringify(this.bag))
         Text(JSON.stringify(this.bag.book))
         Text(JSON.stringify(this.book))
         Button('change bag').onClick(() => {
            this.bag.size = 10
         })
         Button('change book').onClick(() => {
            this.bag.book.name = 'lalala'
         })
      }
   }
}

@Entry
@Component
struct StateDemo {
   @State parent: Parent = new Parent()
   @State child: Child = new Child()
   @State boy: Boy = new Boy()
   @State arr: ObservedArray<string> = new ObservedArray<string>('aa', 'bb', 'cc')
   @State arr2: string[] = ['aa', 'bb', 'cc']
   @State bag: Bag = new Bag(5, new Book('book'))

   build() {
      Column() {
         Text(JSON.stringify(this.parent)).width('100%').fontSize(16).fontColor('black')
         NodeContainer(new OuterTabContentNodeCtrl2(this.parent))
         Text(JSON.stringify(this.child)).width('100%').fontSize(16).fontColor('black')
         NodeContainer(new OuterTabContentNodeCtrl2(this.child))
         Text('' + this.boy.friends)
            .width('100%')
            .fontSize(16)
            .fontColor('black')
         NodeContainer(new OuterTabContentNodeCtrl2(this.boy))
         Text(JSON.stringify(this.arr)).width('100%').fontSize(16).fontColor('black')
         NodeContainer(new OuterTabContentNodeCtrl2(this.arr))
         Text(JSON.stringify(this.arr2)).width('100%').fontSize(16).fontColor('black')
         NodeContainer(new OuterTabContentNodeCtrl2(this.arr2))
         //
         TestComp({
            parent: this.parent,
            child: this.child,
            pArr: this.parent.child,
            cArr: this.child.child
         })
         TestComp2({ bag: this.bag, book: this.bag.book })
         Button().onClick(() => {
            this.bag.size = 8
         })
         Button().onClick(() => {
            this.bag.book.name = 'fafafa'
         })

      }
   }
}