package com.project.exception;

public class CardNotFoundException extends RuntimeException {

	public CardNotFoundException(String message) {
		super(message);
	}
}
