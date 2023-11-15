///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не СтандартныеПодсистемыКлиент.ОтключенаЛогикаНачалаРаботыСистемы() Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ТестовыйРежим.Видимость = Истина;
	
	ЗаголовокТестовогоРежима = "{" + НСтр("ru = 'Тестирование'") + "} ";
	ТекущийЗаголовок = КлиентскоеПриложение.ПолучитьЗаголовок();
	
	Если СтрНачинаетсяС(ТекущийЗаголовок, ЗаголовокТестовогоРежима) Тогда
		Возврат;
	КонецЕсли;
	
	КлиентскоеПриложение.УстановитьЗаголовок(ЗаголовокТестовогоРежима + ТекущийЗаголовок);
	
	ЗарегистрироватьОтключениеЛогикиНачалаРаботыСистемы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ЗарегистрироватьОтключениеЛогикиНачалаРаботыСистемы()
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВладелецДанных = Справочники.ИдентификаторыОбъектовМетаданных.ПолучитьСсылку(
		Новый УникальныйИдентификатор("627a6fb8-872a-11e3-bb87-005056c00008")); // Константы.
	
	ДатыОтключения = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ВладелецДанных); // Массив
	Если ТипЗнч(ДатыОтключения) <> Тип("Массив") Тогда
		ДатыОтключения = Новый Массив;
	КонецЕсли;
	
	ДатыОтключения.Добавить(ТекущаяДатаСеанса());
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ВладелецДанных, ДатыОтключения);
	
КонецПроцедуры

#КонецОбласти
