package samples.pointsto.ex1;

public class Container {
    private Item item = new Item();

    void setItem(Item item) {
      this.item = item;
    }

    Item getItem() {
      return this.item;
    }
}
