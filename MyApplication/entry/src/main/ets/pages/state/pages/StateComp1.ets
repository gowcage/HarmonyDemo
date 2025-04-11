import { Item } from "../StateDemo2";
import hilog from "@ohos.hilog";
import { ObservedArray } from "../../tabs/dropdowntabs/CustomTabContents";

@Component
export struct StateComp1 {
   TAG = 'StateComp1: hiby->'
   @StorageLink('items') @Watch('onchanged') items: ObservedArray<Item> = new ObservedArray()

   onchanged(newValue: string) {
      hilog.debug(0, this.TAG, 'onchanged:' + newValue)
   }

   build() {
      // change item.friends
      List() {
         ForEach(this.items, (item: Item, index: number) => {
            ListItem() {
               Button()
                  .width(60).height(60)
                  .onClick(() => {
                     // this.items[index].friends.push('new friend ' + Math.round(Math.random() * 100))
                     let it = this.items[index]
                     it.friends.push('new friend ' + Math.round(Math.random() * 100))
                     // it.age++
                     this.items[index] = new Item(it.name, it.age)
                     this.items[index].friends = it.friends
                  })
            }
         })
      }
   }
}