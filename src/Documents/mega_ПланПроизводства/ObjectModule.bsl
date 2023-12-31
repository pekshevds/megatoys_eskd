///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОписаниеПеременных

Перем мТаблицаОстатковПроизводственныхРесурсов;
Перем мТаблицаОперацийСпецификаций;
Перем мДатаНачалаПланирования;

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
    	
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();
	
КонецПроцедуры


Процедура ОбработкаПроведения(Отказ, РежимПроведения)
			
	Движения.mega_ПроизводственныеРесурсы.Записывать = Истина;
	ОсвободитьРанееЗанятыеРесурсы();
	
	мДатаНачалаПланирования = Макс(ДатаНачалаПланирования, НачалоДня(ТекущаяДатаСеанса()));
	ИнициализироватьТаблицуОстатковПроизводственныхРесурсов();
	ИнициализироватьТаблицуОперацийСпецификаций();
	
	Для Каждого ТекСтрокаСостав Из Состав Цикл 
		
		ОперацииСпецификации = ПолучитьОперацииСпецификации(ТекСтрокаСостав.Спецификация, ТекСтрокаСостав.Количество);		
		ВремяВыполнения = ОперацииСпецификации.Итог("ВремяВыполнения");
		
		Пока ВремяВыполнения > 0 Цикл 
			
			СоздатьПроводки(ОперацииСпецификации);
			ВремяВыполнения = ОперацииСпецификации.Итог("ВремяВыполнения");
		КонецЦикла;				
	КонецЦикла;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
		
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОсвободитьРанееЗанятыеРесурсы()            
	
	Движения.mega_ПроизводственныеРесурсы.Очистить();
	Движения.mega_ПроизводственныеРесурсы.Записать();	
КонецПроцедуры

Процедура ИнициализироватьТаблицуОстатковПроизводственныхРесурсов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПроизводственныеРесурсы.Ресурс КАК Ресурс,
	|	ПроизводственныеРесурсы.ДатаРесурса КАК ДатаРесурса,
	|	ПроизводственныеРесурсы.ВремяОстаток КАК ВремяОстаток
	|ИЗ
	|	РегистрНакопления.mega_ПроизводственныеРесурсы.Остатки(, ДатаРесурса >= &ДатаНачалаПланирования) КАК ПроизводственныеРесурсы
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ресурс,
	|	ДатаРесурса";
		
	Запрос.УстановитьПараметр("ДатаНачалаПланирования", мДатаНачалаПланирования);
	
	Результат = Запрос.Выполнить();
	мТаблицаОстатковПроизводственныхРесурсов = Результат.Выгрузить();
	мТаблицаОстатковПроизводственныхРесурсов.Индексы.Добавить("Ресурс");
КонецПроцедуры

Процедура ИнициализироватьТаблицуОперацийСпецификаций()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	mega_ПланПроизводстваСостав.Спецификация
	|ПОМЕСТИТЬ втСпецификации
	|ИЗ
	|	Документ.mega_ПланПроизводства.Состав КАК mega_ПланПроизводстваСостав
	|ГДЕ
	|	mega_ПланПроизводстваСостав.Ссылка = &ПланПроизводства
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтадииОбработки.НомерСтроки КАК НомерСтроки,
	|	1 КАК НомерПрохода,
	|	СтадииОбработки.ВидСтадииОбработки КАК ВидСтадииОбработки,
	|	ВЫБОР
	|		КОГДА СтадииОбработки.Количество = 0
	|			ТОГДА 1
	|		ИНАЧЕ СтадииОбработки.Количество
	|	КОНЕЦ КАК НормаПроизводства,
	|	ТехнологическиеОперации.Номенклатура КАК ТехнологическаяОперация,
	|	ТехнологическиеОперации.Номенклатура.ПроизводственныйРесурс КАК ПроизводственныйРесурс,
	|	ТехнологическиеОперации.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	0 КАК Количество,
	//|	ТехнологическиеОперации.ВремяВыполнения / ТехнологическиеОперации.Ссылка.Количество КАК ВремяВыполненияЕдиницы,
	|	ТехнологическиеОперации.Количество / ТехнологическиеОперации.Ссылка.Количество КАК ВремяВыполненияЕдиницы,
	|	0 КАК ВремяВыполнения,
	|	ТехнологическиеОперации.Ссылка КАК Спецификация
	|ИЗ
	|	Справочник.mega_Спецификации.ТехнологическиеОперации КАК ТехнологическиеОперации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.mega_Спецификации.СтадииОбработки КАК СтадииОбработки
	|		ПО ТехнологическиеОперации.Ссылка = СтадииОбработки.Ссылка
	|		И ТехнологическиеОперации.КлючСвязи = СтадииОбработки.КлючСвязи
	|ГДЕ
	|	ТехнологическиеОперации.Ссылка В
	|		(ВЫБРАТЬ
	|			Спецификации.Спецификация
	|		ИЗ
	|			втСпецификации КАК Спецификации)
	|	И
	|		ТехнологическиеОперации.Номенклатура.ПроизводственныйРесурс <> ЗНАЧЕНИЕ(Справочник.mega_ПроизводственныеРесурсы.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
		
	Запрос.УстановитьПараметр("ПланПроизводства", Ссылка);	
	РезультатЗапроса = Запрос.Выполнить();
	
	мТаблицаОперацийСпецификаций = РезультатЗапроса.Выгрузить();
	мТаблицаОперацийСпецификаций.Индексы.Добавить("Спецификация")
КонецПроцедуры

Функция ПолучитьОперацииИзОбщейТаблицыОпераций(Спецификация)
	
	ПостроительОтчета = Новый ПостроительОтчета;
	ПостроительОтчета.ИсточникДанных = Новый ОписаниеИсточникаДанных(мТаблицаОперацийСпецификаций);   
	
	Отбор = ПостроительОтчета.Отбор.Добавить("Спецификация");
    Отбор.ВидСравнения = ВидСравнения.Равно;
    Отбор.Использование  = Истина;
    Отбор.Значение = Спецификация;
    
    Возврат ПостроительОтчета.Результат;
КонецФункции

Функция ПолучитьОперацииСпецификации(Спецификация, Количество = 1)Экспорт
		
	Результат = ПолучитьОперацииИзОбщейТаблицыОпераций(Спецификация);
	
	втОперацииСпецификации = Результат.Выгрузить();
	
	ТаблицаЗначений = Результат.Выгрузить();
	ТаблицаЗначений.Очистить();
	
	Для Каждого Операция Из втОперацииСпецификации Цикл
		
		Если Количество <= Операция.НормаПроизводства Тогда
				
			НоваяСтрока = ТаблицаЗначений.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Операция);
			НоваяСтрока.Количество = Количество;
			НоваяСтрока.ВремяВыполнения = НоваяСтрока.ВремяВыполненияЕдиницы * НоваяСтрока.Количество;
		Иначе
			
			ВременноеКоличество = Количество;
			СчетчикПроходов = Операция.НомерПрохода;
			КоличествоПроходов = Цел(ВременноеКоличество / Операция.НормаПроизводства);
			
			Пока СчетчикПроходов <= КоличествоПроходов Цикл
				
				НоваяСтрока = ТаблицаЗначений.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Операция);
				НоваяСтрока.Количество = Операция.НормаПроизводства;
				НоваяСтрока.ВремяВыполнения = НоваяСтрока.ВремяВыполненияЕдиницы * Операция.НормаПроизводства;
				НоваяСтрока.НомерПрохода = СчетчикПроходов;
				
				ВременноеКоличество = ВременноеКоличество - Операция.НормаПроизводства;
				
				СчетчикПроходов = СчетчикПроходов + 1;
			КонецЦикла;
			
			Если ВременноеКоличество > 0 Тогда
				
				НоваяСтрока = ТаблицаЗначений.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Операция);
				НоваяСтрока.Количество = ВременноеКоличество;
				НоваяСтрока.ВремяВыполнения = НоваяСтрока.ВремяВыполненияЕдиницы * ВременноеКоличество;
				НоваяСтрока.НомерПрохода = СчетчикПроходов;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаЗначений.Сортировать("НомерПрохода,НомерСтроки");
					
	Возврат ТаблицаЗначений;
КонецФункции

Функция ПолучитьОстаткиПроизводственногоРесурса(ПроизводственныйРесурс)
	
	Строки = мТаблицаОстатковПроизводственныхРесурсов.НайтиСтроки(Новый Структура("Ресурс", ПроизводственныйРесурс));
	Возврат Строки;
КонецФункции

Процедура СоздатьПроводки(ОперацииСпецификации)
	
	Для Каждого Операция Из ОперацииСпецификации Цикл 
		
		Время = Операция.ВремяВыполнения;
		ОстаткиПроизводственногоРесурса = ПолучитьОстаткиПроизводственногоРесурса(Операция.ПроизводственныйРесурс);
					
		Для Каждого СтрокаОстатков Из ОстаткиПроизводственногоРесурса Цикл
			
			Если Время <= СтрокаОстатков.ВремяОстаток Тогда
				
				Движение = Движения.mega_ПроизводственныеРесурсы.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Период = Дата;
				Движение.ДатаРесурса = СтрокаОстатков.ДатаРесурса;
				Движение.Ресурс = Операция.ПроизводственныйРесурс;			
				Движение.Время = Время;
				Движение.Количество = Операция.Количество;
				Движение.Спецификация = Операция.Спецификация;
				Движение.ВидСтадииОбработки = Операция.ВидСтадииОбработки;
				Движение.ТехнологическаяОперация = Операция.ТехнологическаяОперация;
				
				Операция.ВремяВыполнения = Операция.ВремяВыполнения - Время;
				
				СтрокаОстатков.ВремяОстаток = СтрокаОстатков.ВремяОстаток - Время;
				Время = 0;
				Прервать;
			КонецЕсли;				
		КонецЦикла;
		
		Если Время > 0 Тогда
			
			СообщениеИсключения =  СтрШаблон("Для технологической операции %1 нет свободного остатка ресурса %2", 
				Операция.ТехнологическаяОперация, Операция.ПроизводственныйРесурс);
				
			ВызватьИсключение СообщениеИсключения;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли