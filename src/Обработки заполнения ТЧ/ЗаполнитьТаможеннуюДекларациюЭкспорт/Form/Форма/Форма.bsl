﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.ОбъектыНазначения) = Тип("Массив") Тогда
		
		Для каждого ДокументСсылка из Параметры.ОбъектыНазначения Цикл
			
			НоваяСтрока = Объект.ОбъектыНазначения.Добавить();
			НоваяСтрока.Документ = ДокументСсылка;
			НоваяСтрока.Номер    = ПолучитьНомер(ДокументСсылка);
			НоваяСтрока.ГТД      = ПолучитьГТД(НоваяСтрока.Номер);
			
		КонецЦикла;	
		
	КонецЕсли;
	
	ОбновитьДокумент = Истина;
	ПрисоединитьФайл = Истина;
	
	ПрочитатьСоотвестивеВидовДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьГТД(Номер)
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Наименование", Номер);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Спр.Ссылка
	|ИЗ
	|	Справочник._НомераГТДЭкспортные КАК Спр
	|ГДЕ
	|	НЕ Спр.ПометкаУдаления
	|	И Спр.Наименование = &Наименование";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Возврат Результат.Выгрузить()[0][0];
	КонецЕсли;	
	
КонецФункции	

&НаСервере
Функция ПрочитатьСоотвестивеВидовДокументов()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Макет = ОбработкаОбъект.ПолучитьМакет("СоотвествиеВидовДокументов");
	
	СоответствиеВидовДокументов = Новый Структура;
	
	Для Счетчик = 2 По Макет.ВысотаТаблицы Цикл
		
		XMLКод = Макет.Область(Счетчик, 1, Счетчик, 1).Текст;
		Если НЕ ПустаяСтрока(XMLКод) Тогда
			
			СоответствиеВидовДокументов.Вставить("К_" + XMLКод, Макет.Область(Счетчик, 2, Счетчик, 2).Текст);
			
		КонецЕсли;	
		
	КонецЦикла;	
	
КонецФункции	

&НаКлиенте
Процедура КаталогНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Показать(Новый ОписаниеОповещения("КаталогНачалоВыбораЗавершение", ЭтаФорма));
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		Объект.Каталог = ВыбранныеФайлы[0];
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура КаталогОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Объект.Каталог);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(ИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Прочитать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НачатьПоискФайовЗавершение", ЭтотОбъект);
	НачатьПоискФайлов(ОписаниеОповещения, Объект.Каталог, "*.xml", Ложь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
// Из формата yyyy-mm-dd в формат ddmmyy
Функция ДатаФормат(Парам)
	
	Массив = СтрРазделить(Парам, "-");
	Возврат Массив[2] + Массив[1] + Прав(Массив[0], 2);
	
КонецФункции	

&НаСервереБезКонтекста
Функция ПолучитьНомер(ДокументСсылка)
	
	Возврат СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "Номер"));
	
КонецФункции	

&НаКлиенте
Процедура НачатьПоискФайовЗавершение(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	Элементы.Индикатор.МаксимальноеЗначение = НайденныеФайлы.Количество();
	Индикатор = 0;
	ЧтениеXML = Новый ЧтениеXML;
	
	Для каждого Файл из НайденныеФайлы Цикл
		
		МассивДокументов = Новый Массив;
		
		СтруктураФайла = Новый Структура;
		СтруктураФайла.Вставить("PresentedDocument", Новый Массив);
		
		ЧтениеXML.ОткрытьФайл(Файл.ПолноеИмя);
		Пока ЧтениеXML.Прочитать() Цикл
			
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				ИмяУзла = ЧтениеXML.Имя;
			КонецЕсли;
			
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента
				И ЧтениеXML.Имя = "PresentedDocument" Тогда
				
				СтруктураPresentedDocument = Новый Структура;
				
			ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента
				И ЧтениеXML.Имя = "PresentedDocument" Тогда
				
				СтруктураPresentedDocument.Вставить("ВидДокумента", "");
				Попытка
					СтруктураPresentedDocument.ВидДокумента = СоответствиеВидовДокументов["К_" + СтруктураPresentedDocument.PresentedDocumentModeCode];
				Исключение
				КонецПопытки;
				
				СтруктураФайла.PresentedDocument.Добавить(СтруктураPresentedDocument);
				
			ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				Если ИмяУзла = "PrDocumentNumber"
					ИЛИ ИмяУзла = "PrDocumentDate"
					ИЛИ ИмяУзла = "PresentedDocumentModeCode" Тогда
					
					СтруктураPresentedDocument.Вставить(ИмяУзла, ЧтениеXML.Значение);	
					
				ИначеЕсли ИмяУзла = "TransportIdentifier"
					ИЛИ ИмяУзла = "TransportModeCode" 
					ИЛИ ИмяУзла = "CustomsCode" 
					ИЛИ ИмяУзла = "RegistrationDate" 
					ИЛИ ИмяУзла = "GTDNumber"
					ИЛИ ИмяУзла = "ExportDate" Тогда
					
					СтруктураФайла.Вставить(ИмяУзла, ЧтениеXML.Значение);	
					
				ИначеЕсли ИмяУзла = "Code" Тогда
					СтруктураФайла.Вставить("Customs_Code", ЧтениеXML.Значение);	
					
				КонецЕсли;	
				
			КонецЕсли;	
			
		КонецЦикла;
		
		ЧтениеXML.Закрыть();
		
		НомерГТДПрочитанный = СтруктураФайла.CustomsCode + "/" + ДатаФормат(СтруктураФайла.RegistrationDate) + "/" + СтруктураФайла.GTDNumber;
		НайденныеСтроки = Объект.ОбъектыНазначения.НайтиСтроки(Новый Структура("Номер", НомерГТДПрочитанный));
		
		Если НайденныеСтроки.Количество() <> 0 Тогда
			
			СтруктураФайла.Вставить("ИмяФайла", Файл.ПолноеИмя);
			НайденныеСтроки[0].Данные  = СтруктураФайла;
			НайденныеСтроки[0].Пометка = Истина;
			
		КонецЕсли;	
		
		Индикатор = Индикатор + 1;
		ОбработкаПрерыванияПользователя();
		
	КонецЦикла;	
	
	ОбъектыНазначенияПриАктивизацииСтроки(Элементы.ОбъектыНазначения);
	Элементы.ФормаПеренестиВДокумент.КнопкаПоУмолчанию = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФормуПоДанным(СтруктураФайла)
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураФайла,, "PresentedDocument");
	PresentedDocument.Очистить();
	Для каждого СтрокаТЗ из СтруктураФайла.PresentedDocument Цикл
		
		НоваяСтрока = PresentedDocument.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЗ);
		
	КонецЦикла;	
	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ЕстьФайл(ДокументСсылка, Наименование)
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("ВладелецФайла", ДокументСсылка);
	Запрос.Параметры.Вставить("Наименование",  Наименование);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Спр.Ссылка
	|ИЗ
	|	Справочник.ТаможеннаяДекларацияЭкспортПрисоединенныеФайлы КАК Спр
	|ГДЕ
	|	Спр.ВладелецФайла = &ВладелецФайла
	|	И Спр.Наименование = &Наименование
	|	И НЕ Спр.ПометкаУдаления";
	
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции	

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Для каждого СтрокаТЧ из Объект.ОбъектыНазначения Цикл
		
		Если ТипЗнч(СтрокаТЧ.Данные) <> Тип("Структура") Тогда
			Продолжить;
		КонецЕсли;	
		
		Наименование = НаименованиеФайла(СтрокаТЧ.Документ, СтрокаТЧ.Номер); 
		Если НЕ ЕстьФайл(СтрокаТЧ.Документ, Наименование)
			И ЗначениеЗаполнено(СтрокаТЧ.Данные.ИмяФайла) Тогда
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("ВладелецФайла",        СтрокаТЧ.Документ);
			ДополнительныеПараметры.Вставить("ИдентификаторФормы",   УникальныйИдентификатор);
			ДополнительныеПараметры.Вставить("ПолноеИмяФайла",       СтрокаТЧ.Данные.ИмяФайла);
			ДополнительныеПараметры.Вставить("ИмяСоздаваемогоФайла", Наименование);
			
			ПрисоединенныеФайлыСлужебныйКлиент.ДобавитьФайлыРасширениеПредложено(Истина, ДополнительныеПараметры);
			
		КонецЕсли;
		
		ЗаполнитьДокумент(СтрокаТЧ.Документ, СтрокаТЧ.ГТД, СтрокаТЧ.Данные);
		
	КонецЦикла;	

	Закрыть();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НаименованиеФайла(Знач ДокументСсылка, Знач НомерГТД)
	
	Дата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "Дата");
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДокДокументыОснования.ДокументОснование.Партнер.Наименование КАК Партнер
	|ИЗ
	|	Документ.ТаможеннаяДекларацияЭкспорт.ДокументыОснования КАК ДокДокументыОснования
	|ГДЕ
	|	ДокДокументыОснования.Ссылка = &Ссылка" ;
	
	Контрагент = "";
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Контрагент = "_" + Результат.Выгрузить()[0][0];
	КонецЕсли;	
	
	Стр = "GoodsExportInfo(" + Формат(Дата, "ДФ=dd.MM.yyyy") + "_" + НомерГТД + Контрагент + ")";
	Стр = СтрЗаменить(Стр, "/", "-");
	
	Возврат Стр;
	
КонецФункции	

&НаСервереБезКонтекста
Процедура ЗаполнитьДокумент(ДокументСсылка, СпрСсылка, Данные)
	
	ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
	
	ДокументОбъект.СопроводительныеДокументы.Очистить();
	
	Для каждого СтрокаТЗ из Данные.PresentedDocument Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаТЗ.ВидДокумента) Тогда
			Продолжить;
		КонецЕсли;	
		
		НоваяСтрока = ДокументОбъект.СопроводительныеДокументы.Добавить();
		НоваяСтрока.КодТС        = Данные.TransportModeCode;
		НоваяСтрока.ВидДокумента = СтрокаТЗ.ВидДокумента;
		НоваяСтрока.НомерТСД     = СтрокаТЗ.PrDocumentNumber;
		НоваяСтрока.ДатаТСД      = вДату(СтрокаТЗ.PrDocumentDate);
		
		Если Данные.Свойство("Customs_Code") Тогда
			УстановитьЗначениеДопРеквизита(ДокументОбъект, ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Таможенный пост (Таможенные декларации на экспорт)"), Данные.Customs_Code);
		КонецЕсли;	
		
		Если Данные.Свойство("ExportDate") Тогда
			УстановитьЗначениеДопРеквизита(ДокументОбъект, ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Дата вывоза (Таможенные декларации на экспорт)"), вДату(Данные.ExportDate));
		КонецЕсли;	
		
	КонецЦикла;	
	
	Если ДокументОбъект.Проведен Тогда
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
	Иначе	
		РежимЗаписи = РежимЗаписиДокумента.Запись;
	КонецЕсли;	
	
	ДокументОбъект.Записать(РежимЗаписи);
	
	Если ЗначениеЗаполнено(СпрСсылка) Тогда
		
		СпрОбъект = СпрСсылка.ПолучитьОбъект();
		Если Ложь Тогда
			СпрОбъект = Справочники._НомераГТДЭкспортные.СоздатьЭлемент();
		КонецЕсли;	
		
		Если Данные.Свойство("Customs_Code") Тогда
			СпрОбъект.ТаможенныйПост = Данные.Customs_Code;
		КонецЕсли;	
		
		Если Данные.Свойство("ExportDate") Тогда
			СпрОбъект.ДатаВывоза     = вДату(Данные.ExportDate);
		КонецЕсли;	
		СпрОбъект.Записать();
		
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Функция вДату(Парам)
	
	Массив = СтрРазделить(Парам, "-");
	
	Попытка
		Возврат Дата(Число(Массив[0]), Число(Массив[1]), Число(Массив[2]));
	Исключение
		Возврат Неопределено;
	КонецПопытки;	
	
КонецФункции	

&НаКлиенте
Процедура ОбъектыНазначенияПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбъектыНазначенияПриАктивизацииСтрокиОбработчик", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыНазначенияПриАктивизацииСтрокиОбработчик()
	
	ТекущиеДанные = Элементы.ОбъектыНазначения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Если ТипЗнч(ТекущиеДанные.Данные) = Тип("Структура") Тогда
		ЗаполнитьФормуПоДанным(ТекущиеДанные.Данные);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция УстановитьЗначениеДопРеквизита(Объект, Свойство, Значение)
	
	НайденныеСтроки = Объект.ДополнительныеРеквизиты.НайтиСтроки(Новый Структура("Свойство", Свойство));
	Если НайденныеСтроки.Количество() > 0 Тогда
		СтрокаТЧ = НайденныеСтроки[0];
	Иначе	
		СтрокаТЧ = Объект.ДополнительныеРеквизиты.Добавить();
		СтрокаТЧ.Свойство = Свойство;
	КонецЕсли;	
	
	СтрокаТЧ.Значение = Значение;
	
КонецФункции	                                                                                       
