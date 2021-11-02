package com.project.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;

import com.project.bean.Card;
import com.project.bean.Station;
import com.project.bean.Transaction;
import com.project.exception.CardNotFoundException;
import com.project.exception.MinimumBalance;
import com.project.model.service.CardService;
import com.project.model.service.StationService;
import com.project.model.service.TransactionService;

@Controller
@SessionAttributes({"card"})
public class MetroController {

	@Autowired
	CardService cardService;
	@Autowired
	StationService stationService;
	@Autowired
	TransactionService transactionService;
	
	@RequestMapping("/")
	public ModelAndView showMenuController() {
		return new ModelAndView("index");
	}
	@RequestMapping("/userPage")
	public ModelAndView userMenuController() {
		return new ModelAndView("userPage");
	}
	@RequestMapping("/createPage")
	public ModelAndView createMenuController() {
		return new ModelAndView("createPage");
	}
	
	@RequestMapping("/login")
	public ModelAndView searchEmployeeController(@RequestParam("cId") int cardId) {
		ModelAndView mv=new ModelAndView();
		try {
		Card card=cardService.checkCard(cardId);
		if(card==null)
			throw new CardNotFoundException("No card with this number");
		mv.addObject("card", card);

		mv.setViewName("clientPage");
		}
		catch(CardNotFoundException e) {
			return new ModelAndView("userPage","msg",-1);
		}
		return mv;
	}
	
	
	@RequestMapping("/create")
	public ModelAndView searchEmployeeController(@RequestParam("name") String name,@RequestParam("balance") int balance) {
		try {
		if(balance<=0)
			throw new MinimumBalance("Balance should be greater than 0");
		}
		catch(MinimumBalance e) {
			return new ModelAndView("createPage","msg",0);
		}
		if(name=="")
			return new ModelAndView("createPage","msg",-2);
		LocalDateTime current = LocalDateTime.now();
		DateTimeFormatter format = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss"); 
		String creationDate = current.format(format);
		int cardID = cardService.returnCardId();			
		Card card = new Card(++cardID,name, balance,creationDate);
		int flag = cardService.storeCardDetails(card);
		String msg ="Added Successfully and your card number is "+cardID;
			if(flag!=0)
				return new ModelAndView("createPage","msg",cardID);
			else
				return new ModelAndView("createPage","msg",-1);
	}
	
	
	@RequestMapping("/details")
	public ModelAndView viewEmployeeController() {
		return new ModelAndView("clientPage","msg",0);
	}
	
	@RequestMapping("/recharge")
	public ModelAndView rechargeEmployeeController() {
		return new ModelAndView("clientPage","msg",-1);
	}
	
	@RequestMapping("/rechargeAmount")
	public ModelAndView rechargeCard(@RequestParam("cardId") int cId,@RequestParam("amount") int amount) {
		if(amount<=0)
			return new ModelAndView("clientPage","msg",-2);
		int amount1 = cardService.rechargeCard(cId,amount);
		int allAmount =cardService.updateCardBalance(cId, amount1);
		Card card=cardService.checkCard(cId);
		card.setBalance(allAmount);
		ModelAndView mv=new ModelAndView("clientPage","msg",allAmount);
		mv.addObject("card", card);
		return mv;
		//return new ModelAndView("clientPage","msg",allAmount);
	}
	
	
	@RequestMapping("/swipe")
	public ModelAndView swipeStationController(@RequestParam("cId") int cId) {
		Card card=cardService.checkCard(cId);
		int transaction = transactionService.swipeInStatus(card);
		ArrayList<Station> stations = stationService.getStations();
		//System.out.println(stations);
		if(transaction<=0)
			return new ModelAndView("clientPage","swipeIn",stations);
		return new ModelAndView("clientPage","swipeOut",stations);
	}
	@RequestMapping("/swipeIn")
	public ModelAndView swipeInStationController(@RequestParam("cId") int cId,@RequestParam("stations") String stationName) {
		Card card=cardService.checkCard(cId);
		int transaction = transactionService.swipeInStatus(card);
		Station station = stationService.checkStation(stationName);
		if(transaction<=0) {
			boolean flag = transactionService.swipeInCard(card, station);
			return new ModelAndView("clientPage","status","You have successfully swiped in at the station "+stationName);
		}
		return new ModelAndView("clientPage","status","Some Error");
	}
	@RequestMapping("/swipeOut")
	public ModelAndView swipeOutStationController(@RequestParam("cId") int cId,@RequestParam("stations") String stationName) {
		Card card=cardService.checkCard(cId);
		boolean flag;
		int balance2;
		int transaction = transactionService.swipeInStatus(card);
		Station station = stationService.checkStation(stationName);
		int penality = transactionService.checkPenality(transaction);
		penality=penality<=-1?0:penality;
		Card card1= cardService.checkCard(cId);
		int remainingBalance = stationService.swipeOutCard(card1, station.getStationId(),1);
		remainingBalance=remainingBalance-penality*20;
		if(remainingBalance<0)
			return new ModelAndView("clientPage","negative",Math.abs(remainingBalance));
		else {
			if(penality!=0)
				flag= transactionService.updatePenality(transaction,penality*20);
			balance2=stationService.swipeOutCard(card1, station.getStationId(), 2);
			int balance3 = cardService.updateCardBalance(cId, remainingBalance);
			Transaction transaction1=new Transaction();
				transaction1=transactionService.displayDetails(transaction);
			transaction1.setDestinationStationId(station.getStationId());
			transaction1.setFare(balance2);
			transaction1.setPenality(penality*20);
			LocalDateTime current = LocalDateTime.now();
			DateTimeFormatter format = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss"); 
			String creationDate = current.format(format);
			transaction1.setSwipeOutTime(creationDate);
			System.out.println(transaction1);
			card.setBalance(remainingBalance);
			ModelAndView mv=new ModelAndView("clientPage","transaction",transaction1);
			mv.addObject("card", card);
			return mv;
		}
	}
	@RequestMapping("/history")
	public ModelAndView historyController(@RequestParam("cId") int cId) {
		Card card = cardService.checkCard(cId);
		ArrayList<Transaction> transactions = transactionService.getTransaction(card);
		return new ModelAndView("clientPage","transactions",transactions);
	}
	
	@RequestMapping("/logout")
	public ModelAndView logoutController(SessionStatus status) {
		status.setComplete();
		return new ModelAndView("index");
	}
}
