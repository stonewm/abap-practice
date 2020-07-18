
public class Student {
    private String sid;
    private String name;
    private int age;
    private String currentClass;

    public Student(String sid, String name, int age, String current_class) {
        this.sid = sid;
        this.name = name;
        this.age = age;
        this.currentClass = current_class;
    }

    @Override
    public String toString() {
        return String.format(
            "<Student (Id: %s, Name: %s, Age: %d, Class: %s)>", 
            this.sid, this.name, this.age, this.currentClass);
    }

    public void setAge(int newAge) {
        this.age = newAge;
    }

    public void setClass(String newClass) {
        this.currentClass = newClass;
    }
}

class StudentTest {
    public static void main(String[] args) {
        Student s1 = new Student("001", "小王", 15, "高一(5班");
        s1.setAge(16);
        s1.setClass("高二(5)班");
        System.out.println(s1.toString());
    }
}