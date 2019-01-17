//
//  Closure+Extensions.swift
//
//

typealias CompletionChangeHandler<ChangeValue> = (ChangeValue) -> Void
typealias CompletionHandler = () -> Void
typealias CompletionActionHandler = (Bool) -> Void
typealias CompletionErrorHandler = (Error?) -> Void
typealias CompletionSuccessHandler = (Bool, Error?) -> Void
typealias CompletionResponseHandler<Value> = (Value?, Error?) -> Void
