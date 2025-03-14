@Preview
@Component
struct Temp {
   build() {
      Column() {
         Text("Folder xxx").border({ width: 1, color: 'black' })
         Text("XXX").border({ width: 1, color: 'black' })
         Text('OOOO')
            .fontSize(16)
            .fontWeight(300)
            .padding({left: 10, right: 10})
            .border({ width: { bottom: 2 }, color: 'black' })
      }
   }
}