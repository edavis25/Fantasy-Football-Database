package fantasy.library;

/**
 * Eric Davis - October 13, 2016
 */

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

public class CSVReader 
{
	ArrayList<ArrayList<String>> rowArray = new ArrayList<ArrayList<String>>();
	
	File myFile;
	int numberColumns;
	String delimeter;
	
	/**
	 * Default constructor. Creates an object to interact with a given .csv file.
	 * @param inputFile .csv file to read.
	 * @param columns Number of columns in the .csv file.
	 * @param delim Delimeter used in the .csv file.
	 */
	public CSVReader(File inputFile, int columns, String delim)
	{
		myFile = inputFile;
		numberColumns = columns;
		delimeter = delim;
					
		createArray();
	}
	
	/**
	 * Returns the entire .csv file as an Array List containing Array Lists of String values.
	 * The outer array identifies each row and the inner array contains the values from each of the columns.
	 * @return Return the entire .csv as an ArrayList.
	 */
	public ArrayList<ArrayList<String>> getAsArray()
	{
		return rowArray;
	}
	
	/**
	 * Prints all of the values from the given row to console.
	 * @param row Desired row to print.
	 */
	public void printSelectedRow(int row)
	{
		for (String string : rowArray.get(row -1))
		{
			System.out.print(string + ", ");
		}
		System.out.println();
	}
	
	/**
	 * Prints all of the values from the given rows to console. 
	 * @param rows Integer array containing desired rows to print
	 */
	public void printSelectedRows(int[] rows)
	{
		for (int i = 0, size = rows.length; i < size; i++)
		{
			printSelectedRow(rows[i]);
		}
	}
	
	/**
	 * Return all of the values from desired row as a single string value.
	 * @param row Desired row to retrieve values.
	 * @return String value containing all the values from desired row.
	 */
	public String getSelectedRowAsString(int row)
	{
		String returnString = "";
		for (String string : rowArray.get(row -1))
		{
			//System.out.print(string + ", ");
			returnString += string + ", ";
		}
		return returnString;
	}
	
	/**
	 * Return all of the values from desired rows as a String[] Array.
	 * @param rows Integer array containing desired rows to retrieve data.
	 * @return String[] Array containing all the values from desired rows.
	 */
	public String[] getSelectedRowsAsString(int[] rows)
	{
		String[] returnArray = new String[rows.length];
		
		for (int i = 0, size = rows.length; i < size; i++)
		{
			returnArray[i] = getSelectedRowAsString(rows[i]);
		}
		return returnArray;
	}
	
	/**
	 * Prints all of the values from the given column to the console.
	 * @param column Desired column to print.
	 */
	public void printSelectedColumn(int column)
	{
		for (ArrayList<String> row : rowArray)
		{
			System.out.println(row.get(column -1));
		}
	}
	
	/**
	 * Prints all of the values from the given columns to the console.
	 * @param columns Integer array containing desired columns to print.
	 */
	public void printSelectedColumns(int[] columns)
	{
		for (ArrayList<String> row : rowArray)
		{
			for (int i = 0, size = columns.length; i < size; i++)
			{
				System.out.print(row.get(columns[i] -1) + ", ");
			}
			System.out.println();
		}
	}

	/**
	 * Return all of the values from the desired column as a String[] array.
	 * @param column Column number to retrieve data.
	 * @return String[] Array containing data retrieved from column.
	 */
	public String[] getSelectedColumnAsString(int column)
	{
		String[] returnArray = new String[rowArray.size()];
		int counter = 0;
		for (ArrayList<String> row : rowArray)
		{
			if (row.get(column).isEmpty()) continue;
			returnArray[counter] = row.get(column);
			counter++;
		}
		return returnArray;
	}
	
	
	public double[] getSelectedColumnAsDouble(int column)
	{
		double[] returnArray = new double[rowArray.size()];
		int counter = 0;
		for (ArrayList<String> row : rowArray)
		{
			if (row.get(column).isEmpty()) continue;
			returnArray[counter] = Double.parseDouble(row.get(column));
			counter++;
		}
		return returnArray;
	}
	
	/**
	 * Prints the entire .csv file to the console
	 */
	public void printCSV()
	{
		for (ArrayList<String> row : rowArray)
		{
			for (String string : row)
			{
				System.out.print(string + ", ");
			}
			System.out.println();
		}
	}

	/**
	 * Creates a 2 dimensional Array List to match the CSV file table. Outer ArrayList (rowArray) contains
	 * ArrayLists of String type. Outer array = row; inner array = column. Declaration: ArrayList<ArrayList<String>>
	 */
	private void createArray()
	{
		try 
		{
			Scanner scan = new Scanner(myFile);
			
			int counter = 0;
			while (scan.hasNextLine())
			{
				rowArray.add(new ArrayList<String>());
				
				// Get scan as string and find delimiters
				final String localString = scan.nextLine();
				if (localString.isEmpty()) continue;
				ArrayList<Integer> delimeterIndexArray = new ArrayList<Integer>();
				for (int i = 0; i < numberColumns; i++)
				{
					String string;

					if (i == 0)
					{
						delimeterIndexArray.add(localString.indexOf(delimeter));
						string = localString.substring(0, delimeterIndexArray.get(0));
						
						rowArray.get(counter).add(string);
					}
					else if (i == numberColumns -1)
					{
						string = localString.substring(delimeterIndexArray.get(i-1) +1);
					
						rowArray.get(counter).add(string);

						break;
					}
					else
					{
						delimeterIndexArray.add(localString.indexOf(delimeter, delimeterIndexArray.get(i -1) +1));
						string = localString.substring(delimeterIndexArray.get(i-1) +1, delimeterIndexArray.get(i));
						
						rowArray.get(counter).add(string);
					}
				}			
				counter++;
			}		
			scan.close();
		}		
		catch (FileNotFoundException e) 
		{
			e.printStackTrace();
			System.out.println("Error CSVReader");
		}
	} 
}
