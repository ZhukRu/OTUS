﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция СтатусыДоставки(ИдентификаторыСообщений) Экспорт
	
	ОтправкаSMS.ПроверитьПрава();
	СписокИдентификаторов = СтрРазделить(ИдентификаторыСообщений, ",", Ложь);
	СтатусыДоставки = Новый Соответствие();
	
	Для Каждого ИдентификаторСообщения Из СписокИдентификаторов Цикл
		СтатусыДоставки[ИдентификаторСообщения] = "Ошибка";
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(СписокИдентификаторов) Тогда
		Возврат Новый ФиксированноеСоответствие(СтатусыДоставки);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиОтправкиSMS = ОтправкаSMS.НастройкиОтправкиSMS();
	УстановитьПривилегированныйРежим(Ложь);
	
	МодульОтправкаSMSЧерезПровайдера = ОтправкаSMS.МодульОтправкаSMSЧерезПровайдера(НастройкиОтправкиSMS.Провайдер);
	Если МодульОтправкаSMSЧерезПровайдера <> Неопределено Тогда
		НастройкиПровайдера = ОтправкаSMS.НастройкиПровайдера(НастройкиОтправкиSMS.Провайдер);
		
		Если НастройкиПровайдера.СтатусыДоставкиОднимЗапросом Тогда
			СтатусыДоставки = МодульОтправкаSMSЧерезПровайдера.СтатусыДоставки(СписокИдентификаторов, НастройкиОтправкиSMS);
		Иначе
			Для Каждого ИдентификаторСообщения Из СписокИдентификаторов Цикл
				СтатусыДоставки[ИдентификаторСообщения] = МодульОтправкаSMSЧерезПровайдера.СтатусДоставки(ИдентификаторСообщения, НастройкиОтправкиSMS);
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(НастройкиОтправкиSMS.Провайдер) Тогда
		Для Каждого ИдентификаторСообщения Из СписокИдентификаторов Цикл
			Результат = Неопределено;
			ОтправкаSMSПереопределяемый.СтатусДоставки(ИдентификаторСообщения, НастройкиОтправкиSMS.Провайдер,
				НастройкиОтправкиSMS.Логин, НастройкиОтправкиSMS.Пароль, Результат);
			
			СтатусыДоставки[ИдентификаторСообщения] = Результат;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Новый ФиксированноеСоответствие(СтатусыДоставки);
	
КонецФункции

Функция ДоступнаОтправкаSMS() Экспорт
	
	Возврат ПравоДоступа("Просмотр", Метаданные.ОбщиеФормы.ОтправкаSMS) И ОтправкаSMS.НастройкаОтправкиSMSВыполнена()
		Или Пользователи.ЭтоПолноправныйПользователь();
	
КонецФункции

#КонецОбласти