import java.util.ArrayList;
import java.util.List;

import org.openqa.selenium.WebElement;

public class CreateArray 
{
	public static List<String> getListAsArray(List<WebElement> elementList)
	{
		List<String> returnList = new ArrayList<>();
		
		for (WebElement element : elementList)
		{
			returnList.add(element.getText());
		}
		
		return returnList;
	}
}
