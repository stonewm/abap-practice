public class Book {
    private String title;
    private String author;
    private String publisher;
    private double price;

    public Book(String title, String author, String publisher, double price) {
        this.title = title;
        this.author = author;
        this.publisher = publisher;
        this.price = price;
    }

    public void setPrice(double newPrice) {
        this.price = newPrice;
    }

    public void printInfo() {
        System.out.println(String.format(
            "Title: %s\nAuthor: %s\nPublisher: %s\nPrice: %f", 
            this.title, this.author, this.publisher, this.price));
    }
}

class BookTest {
    public static void main(String[] args) {
        Book book1 = new Book("窗边的小豆豆", "黑柳彻子", "南海出版公司", 39.5);        
        Book book2 = new Book("人间失格", "太宰治", "作家出版社", 18.8);

        book1.printInfo();

        book2.setPrice(22);
        book2.printInfo();
    }
}