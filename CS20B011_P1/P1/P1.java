import syntaxtree.*;
import visitor.*;
import java.util.*;

public class P1 {
   public static void main(String [] args) 
   {
      try {
         Node root = new MiniJavaParser(System.in).Goal();
         GJDepthFirst df = new GJDepthFirst();
         root.accept(df, null);
         System.out.println("Program type checked successfully");

      }
      catch (ParseException e) 
      {
         //System.out.println(e.toString());
         System.out.println("Type error");
      }
   }
}

