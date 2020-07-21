public class Book {
    public String Title;
    public String Author;
    public String Publisher;
    public double Price;

    public void printInfo() {
        
        System.out.println(String.format("Title: %s\nAuthor: %s\nPublisher: %s\nPrice: %f", 
            this.Title, this.Author, this.Publisher, this.Price)
        );        
    }
}

class BookTest {
    public static void main(String[] args) {
        Book book1 = new Book();
        book1.Title = "窗边的小豆豆";
        book1.Author = "黑柳彻子";
        book1.Publisher = "南海出版公司";
        book1.Price = 39.5;

        Book book2 = new Book();
        book2.Title = "人间失格";
        book2.Author = "太宰治";
        book2.Publisher = "作家出版社";
        book2.Price = 18.8;

        book1.printInfo();
        book2.printInfo();
    }
}