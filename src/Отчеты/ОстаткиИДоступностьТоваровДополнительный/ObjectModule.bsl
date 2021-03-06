﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = Новый Структура;
	МассивНазначений = Новый Массив;
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.2.1");
	ПараметрыРегистрации.Вид          = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительныйОтчет();
	ПараметрыРегистрации.Наименование = Метаданные().Представление() + " (дополнительный)";
	ПараметрыРегистрации.Версия       = Метаданные().Комментарий;
	ПараметрыРегистрации.Назначение   = МассивНазначений;
	ПараметрыРегистрации.БезопасныйРежим = Истина;
	
	ДобавитьКоманду(ПараметрыРегистрации.Команды, "Остатки и доступность товаров (дополнительный)", "Остатки и доступность товаров (дополнительный)", ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы(), Ложь, "ПечатьMXL");
		
	Возврат ПараметрыРегистрации;	
		
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	
КонецПроцедуры
	
#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;

	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	// Вызов из самообслуживания.
	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		ПараметрВыводитьОтбор = КомпоновщикНастроек.Настройки.ПараметрыВывода.Элементы.Найти("ВыводитьОтбор");
		Если ПараметрВыводитьОтбор <> Неопределено Тогда
			ПараметрВыводитьОтбор.Использование = Истина;
			ПараметрВыводитьОтбор.Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить;
		КонецЕсли;
	КонецЕсли;

	// Стандартная компоновка отчета.
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ДокументРезультат.ПоказатьУровеньГруппировокКолонок(0);
	
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	
КонецПроцедуры

Функция ВспомогательныеПараметрыОтчета()
	
	ВспомогательныеПараметры = Новый Массив;
	
	КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	
	Возврат ВспомогательныеПараметры;

КонецФункции

#КонецОбласти

#КонецЕсли