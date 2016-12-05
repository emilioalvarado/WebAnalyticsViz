package com.dashboard.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.dashboard.model.ChartModel;
import com.dashboard.model.TableModel;
import com.google.gson.Gson;


@Controller
@Component
public class BIController {
	

	@RequestMapping(value ="/" , method = { RequestMethod.GET, RequestMethod.POST })
	
	public String indexMethod(HttpServletRequest req ,ModelMap model) throws ParseException, IOException, SQLException
	{
		String minVal = req.getParameter("minVal");
		String  maxVal= req.getParameter("maxVal");
		//System.out.println(minVal +" "+maxVal);
		if(minVal == null)
		 minVal ="0";
	
		if(maxVal==null)
			maxVal ="20000";
		
		model.addAttribute("minVal", minVal);
		model.addAttribute("maxVal", maxVal);
		return "index";
	}
	
	@RequestMapping(value ="/index" , method = { RequestMethod.GET, RequestMethod.POST })
	
	public String indexRepeatMethod(HttpServletRequest req ,ModelMap model) throws ParseException, IOException, SQLException
	{
		String minVal = req.getParameter("minVal");
		String  maxVal= req.getParameter("maxVal");
		System.out.println(minVal +" "+maxVal);
		if(minVal == null)
		 minVal ="0";
	
		if(maxVal==null)
			maxVal ="20000";
		
		BufferedReader br = null;
		FileReader fr = null;
		Map<String, Integer>map = new HashMap<>();
		List<ChartModel> chartModels = new ArrayList<>();
		try {
			String sCurrentLine;
			br = new BufferedReader(new FileReader("D:\\temp\\VA\\sunburst_sequences.txt"));
			PrintWriter pw = new PrintWriter("D:\\temp\\VA\\sunburst_modified.txt");
			
			int count =0;
			while ((sCurrentLine = br.readLine()) != null) {
			
				String A[] =sCurrentLine.split(",");
				if(A.length <2)continue;
				if(Integer.parseInt( A[1] ) < Integer.parseInt(minVal) || Integer.parseInt( A[1] ) > Integer.parseInt(maxVal))
				{
					continue;
				}
				if(count!=0)
					pw.write("\n");
				count++;
				pw.write(sCurrentLine);
			}
			pw.close();
		} catch (IOException e) {

			e.printStackTrace();

		} finally {

			try {

				if (br != null)
					br.close();

				if (fr != null)
					fr.close();

			} catch (IOException ex) {

				ex.printStackTrace();

			}

		}
		model.addAttribute("minVal", minVal);
		model.addAttribute("maxVal", maxVal);
		return "Sunburst";
	}
	@RequestMapping(value ="/generateChart" , method = { RequestMethod.GET, RequestMethod.POST })
	@ResponseBody
	public String chartMethod(@RequestParam("dataSend") String urlSearch,HttpServletRequest req ,ModelMap model) throws ParseException, IOException, SQLException
	{
		BufferedReader br = null;
		FileReader fr = null;
		Map<String, Integer>map = new HashMap<>();
		List<ChartModel> chartModels = new ArrayList<>();
		try {
			String sCurrentLine;

			br = new BufferedReader(new FileReader("D:\\temp\\VA\\aggregated_dataset.txt"));
			
			int count =0;
			while ((sCurrentLine = br.readLine()) != null) {
				String A[] =sCurrentLine.split(",");
				//System.out.println(count++);
				for(int i=0;i<A.length;i++)
				{
					
					
					String ans = A[i].trim();
					//System.out.println(ans +" KKAKA "+ urlSearch);
					if(ans.equals(urlSearch))
					{
						//System.out.println("inside");
						DateFormat format = new SimpleDateFormat("yyyy-dd-mm");
						Date date = format.parse(A[3]);
						if(map.containsKey(A[3]))
						{
							//System.out.println(A[3]);
							int val = map.get(A[3]);
							map.put(A[3], val+1);
						}
						else
						{
							map.put(A[3], 1);
						}
					}
				}
			}

		} catch (IOException e) {

			e.printStackTrace();

		} finally {

			try {

				if (br != null)
					br.close();

				if (fr != null)
					fr.close();

			} catch (IOException ex) {

				ex.printStackTrace();

			}

		}
		Iterator it = map.entrySet().iterator();
	    while (it.hasNext()) {
	        Map.Entry pair = (Map.Entry)it.next();
	        ChartModel  chartModel = new ChartModel();
	        String date = (String) pair.getKey();
	        int val = (int) pair.getValue();
	        chartModel.setDate(date);
	        chartModel.setVisits(val);
	        chartModels.add(chartModel);
	        it.remove(); // avoids a ConcurrentModificationException
	    }
		String fans= new Gson().toJson(chartModels);
		System.out.println(fans +"PPPP");
		return fans;
	}
	@RequestMapping(value ="/generateTable" , method = { RequestMethod.GET, RequestMethod.POST })
	@ResponseBody
	public String tableMethod(@RequestParam("dataSend") String urlSearch,@RequestParam("date") String date,HttpServletRequest req ,ModelMap model) throws ParseException, IOException, SQLException
	{
		BufferedReader br = null;
		FileReader fr = null;
		Map<String, Integer>map = new HashMap<>();
		List<TableModel> tableModels = new ArrayList<>();
		try {
			String sCurrentLine;

			br = new BufferedReader(new FileReader("D:\\temp\\VA\\aggregated_dataset.txt"));
			
			int count =0;
			while ((sCurrentLine = br.readLine()) != null) {
				String A[] =sCurrentLine.split(",");
				
					if(A.length != 8)
						continue;
							
					//System.out.println(count++ + " "+ A.length);
				
					String dateTemp = A[3].trim();
					String navTemp = A[7].trim();
					//System.out.println(ans +" KKAKA "+ urlSearch);
					if(navTemp.equals(urlSearch) && dateTemp.equals(date))
					{
						//System.out.println("inside");
						TableModel tableModel = new TableModel();
						tableModel.setDateStmp(date+A[4]);
						tableModel.setNavPath(navTemp);
						tableModel.setUserId(A[0]);
						tableModel.setDomainUserId(A[1]);
						tableModel.setDomainSessionId(A[2]);
						tableModel.setPageUrl(A[5]);
						tableModels.add(tableModel);
					
				}
			}

		} catch (IOException e) {

			e.printStackTrace();

		} finally {

			try {

				if (br != null)
					br.close();

				if (fr != null)
					fr.close();

			} catch (IOException ex) {

				ex.printStackTrace();

			}

		}

		String fans= new Gson().toJson(tableModels);
		System.out.println(fans +"PPPP");
		return fans;
	}
}
