///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		УстановитьПривилегированныйРежим(Истина);
		ПарольУстановлен = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Объект.Ссылка) <> "";
		УстановитьПривилегированныйРежим(Ложь);
		ПарольПриложения = ?(ПарольУстановлен, ЭтотОбъект.УникальныйИдентификатор, "");
		ПарольИзменен = Ложь;
		РаботаСПочтовымиСообщениямиСлужебный.ОформитьПолеПароля(Элементы.ПарольПриложения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПарольИзменен Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Ссылка, ПарольПриложения, "ПарольПриложения");
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриложенияИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Элементы.ПарольПриложения.КнопкаВыбора = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПарольПриложенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСПочтовымиСообщениямиКлиент.ПолеПароляНачалоВыбора(Элемент, ПарольПриложения, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти
