@Entry
@Component
export struct OtherDemos {
   build() {
     Column(){
        Text().width(200).height(50).backgroundColor('black').borderWidth(1).borderColor('#ffde663d')
        Text().width(200).height(50).backgroundColor('white').borderWidth(1).borderColor('#ffde663d')
        Text().width(200).height(50).backgroundColor('gray').borderWidth(1).borderColor('#ffde663d')
        Text().width(200).height(50).backgroundColor('red').borderWidth(1).borderColor('#ffde663d')
        Text().width(200).height(50).backgroundColor('green').borderWidth(1).borderColor('#ffde663d')
        Text().width(200).height(50).backgroundColor('blue').borderWidth(1).borderColor('#ffde663d')
     }
   }
}