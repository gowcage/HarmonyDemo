import { Book, CompA } from "./CustomComp"

@Entry
@Component
export struct NodeControllerDemo {
   // @Provider() pageinfo: Book = new Book('node book name')
   @Provide pageinfo: Book = new Book('node book name')
   build() {
      Column(){
         CompA()
      }
   }
}