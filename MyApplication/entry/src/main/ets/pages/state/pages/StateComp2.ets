export class StateComp2 {
   static readonly KEY_AGE = 'state1_age'
   static readonly KEY_WEIGHT = 'state1_weight'
   static readonly KEY_UNAME = 'state1_uname'
   static readonly KEY_PWD = 'state1_pwd'

   static setAge(age: number) {
      AppStorage.setOrCreate(StateComp2.KEY_AGE, age)
   }

   static getAge(): number {
      let ret: number | undefined = AppStorage.get(StateComp2.KEY_AGE)
      return ret ? ret : 0
   }

   static setWeight(weight: number) {
      AppStorage.setOrCreate(StateComp2.KEY_WEIGHT, weight)
   }

   static getWeight(): number {
      let ret: number | undefined = AppStorage.get(StateComp2.KEY_WEIGHT)
      return ret ? ret : 0
   }

   static setUname(uname: string) {
      AppStorage.setOrCreate(StateComp2.KEY_UNAME, uname)
   }

   static getUname(): string {
      let ret: string | undefined = AppStorage.get(StateComp2.KEY_UNAME)
      return ret ? ret : ''
   }

   static setPwd(pwd: string) {
      AppStorage.setOrCreate(StateComp2.KEY_PWD, pwd)
   }

   static getPwd(): string {
      let ret: string | undefined = AppStorage.get(StateComp2.KEY_PWD)
      return ret ? ret : ''
   }

   static changeArr(arr:string[]){
      arr[1] = 'd'
      arr.push('new')
   }

   // ...

   build() {
   }
}