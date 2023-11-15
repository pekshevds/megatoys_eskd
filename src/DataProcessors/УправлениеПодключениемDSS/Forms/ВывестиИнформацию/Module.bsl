///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ПрограммноеЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТаймАут = Параметры.ТаймАут;
	РежимОтображения = Параметры.РежимОтображения;
	ВходнойТекст = Параметры.ТекстСообщения;
	ПараметрыОперации = Параметры.ПараметрыОперации;
	Заголовок = Параметры.Заголовок;
	
	Элементы.ГруппаОшибка.Видимость = Ложь;
	Если РежимОтображения = "Ошибка" Тогда
		ПодготовитьФормуОшибки(ВходнойТекст);
		
	ИначеЕсли РежимОтображения = "Информация" Тогда
		ПодготовитьФормуИнформации(ВходнойТекст);
		
	ИначеЕсли РежимОтображения = "Вопрос" Тогда
		ПодготовитьФормуВопроса(ВходнойТекст);
		
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = РежимОтображения;
	
	Элементы.ЖурналОшибок.Видимость = РежимОтображения = "Ошибка";
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СервисКриптографииDSSСлужебныйКлиент.ПриОткрытииФормы(ЭтотОбъект, ПрограммноеЗакрытие);
	ПодключитьОбработчикОжидания("Подключаемый_ИзменитьРазмерыФормы", 0.2, Истина);
	
	Если ЗначениеЗаполнено(ТаймАут) Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьФорму", ТаймАут, Истина);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если СервисКриптографииDSSСлужебныйКлиент.ПередЗакрытиемФормы(
			ЭтотОбъект,
			Отказ,
			ПрограммноеЗакрытие,
			ЗавершениеРаботы) Тогда
		ЗакрытьФорму();
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ЖурналОшибок(Элемент)
	
	Отбор = Новый Структура;
	Отбор.Вставить("СобытиеЖурналаРегистрации", СервисКриптографииDSSКлиентСервер.ИмяСобытияЖурналаРегистрации());
	Отбор.Вставить("Уровень",                   "Ошибка");
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(Отбор, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуИнформации(ВходнойТекст)
	
	Элементы.ГруппаРежимы.ТекущаяСтраница = Элементы.ГруппаИнформация;
	Элементы.ДекорацияИнформация.Заголовок = ВходнойТекст;
	УстановитьКартинку("ДиалогИнформация");
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуОшибки(ВходнойТекст)
	
	КодЯзыка = СервисКриптографииDSSСлужебный.КодЯзыка();
	
	Элементы.ГруппаОшибка.Видимость = Истина;
	Элементы.ГруппаРежимы.ТекущаяСтраница = Элементы.ГруппаОшибка;
	Если Параметры.ЭтоКодОшибки Тогда
		ВходнойТекст = СервисКриптографииDSSСлужебный.ПолучитьОписаниеОшибки(Неопределено, ВходнойТекст);
	КонецЕсли;	
	
	КодОшибки = СервисКриптографииDSSКлиентСервер.ПолучитьКодОшибки(ВходнойТекст);
		
	Если ЗначениеЗаполнено(КодОшибки) Тогда
		ТекстСообщения = Сред(ВходнойТекст, 8);
	Иначе
		ТекстСообщения = ВходнойТекст;
	КонецЕсли;
	
	СодержаниеОшибки = СокрЛП(ТекстСообщения);
	
	Если ПустаяСтрока(КодОшибки) Тогда
		Элементы.КодОшибки.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		КодОшибки = НСтр("ru = 'Обнаружена ошибка'");
	КонецЕсли;
	
	Заголовок = НСтр("ru = 'Ошибка при работе сервиса DSS'", КодЯзыка);
	УстановитьКартинку("ДиалогСтоп");

КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуВопроса(ВходнойТекст)
	
	Элементы.ГруппаРежимы.ТекущаяСтраница = Элементы.ГруппаИнформация;
	Заголовок = Параметры.Заголовок;
	Элементы.ДекорацияИнформация.Заголовок = ВходнойТекст;
	Элементы.ГруппаЗакрыть.Видимость = Ложь;
	УстановитьКартинку("ДиалогВопрос");
	
	ПервыйЭлемент = Неопределено;
	
	Для Счетчик = 1 По Параметры.СписокКоманд.Количество() Цикл
		СтрокаКоманды = Параметры.СписокКоманд[Счетчик - 1];
		ИмяКоманды = СтрокаКоманды.Значение;
		
		НоваяКоманда = Команды.Добавить(ИмяКоманды);
		НоваяКоманда.Действие = "Подключаемый_НажатиеКнопки"; 
		НоваяКоманда.Заголовок = СтрокаКоманды.Представление;
		Если ЗначениеЗаполнено(СтрокаКоманды.Картинка) Тогда
			НоваяКоманда.Картинка = СтрокаКоманды.Картинка;
		КонецЕсли;
		
		НовыйЭлемент = Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Элементы.ГруппаВопросы);
		НовыйЭлемент.ИмяКоманды = ИмяКоманды;
		
		Если ПервыйЭлемент = Неопределено ИЛИ СтрокаКоманды.Пометка Тогда
			ПервыйЭлемент = НовыйЭлемент;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПервыйЭлемент <> Неопределено Тогда
		ПервыйЭлемент.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
	ОтображатьКнопкуЗакрытия = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКартинку(ИмяКартинки)
	
	НашлиКартинку = СервисКриптографииDSS.ПолучитьКартинкуПодсистемы(ИмяКартинки);
	
	Если НашлиКартинку.Вид <> ВидКартинки.Пустая Тогда
		Элементы.ДекорацияКартинка.Картинка = НашлиКартинку;
	Иначе
		Элементы.ДекорацияКартинка.Картинка = Новый Картинка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ИзменитьРазмерыФормы()
	
	Элементы.ГруппаЛевая.Видимость = НЕ Элементы.ГруппаЛевая.Видимость;
	Элементы.ГруппаЛевая.Видимость = НЕ Элементы.ГруппаЛевая.Видимость;
	
	Если РежимОтображения <> "Вопрос" Тогда
		ТекущийЭлемент = Элементы.Закрыть;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Элементы.ДекорацияКартинка.Картинка) Тогда
		Элементы.ДекорацияКартинка.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Выполняет событие нажатия кнопки
//
// Параметры:
//  Команда - КомандаФормы
//
//@skip-warning
//
&НаКлиенте
Процедура Подключаемый_НажатиеКнопки(Команда)
	
	ЗакрытьФорму(Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	ЗакрытьФорму("ТаймАут");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(РезультатВыбора = "")
	
	ПрограммноеЗакрытие = Истина;
	Если РежимОтображения = "Вопрос" Тогда
		ПараметрыОперации = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Истина);
		ПараметрыОперации.Вставить("Результат", РезультатВыбора);
		
	ИначеЕсли ТипЗнч(ПараметрыОперации) <> Тип("Структура")
		ИЛИ ПараметрыОперации.Количество() = 0 Тогда
		ПараметрыОперации = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Истина);
		
	КонецЕсли;
	
	Закрыть(ПараметрыОперации);
	
КонецПроцедуры

#КонецОбласти

