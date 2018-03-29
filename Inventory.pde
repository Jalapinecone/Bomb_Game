class Inventory{
  Item item;
  
  Inventory(){
    this.item = null;
  }
  
  void add(Item item){
    this.item = item;
  }
  
  void remove(){
    this.item = null;
  }
  
  boolean checkItems(){
    if(item == null){
      return false;
    }
    return true;
  }
}