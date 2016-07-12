﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектСсылка = Параметры.ДополнительнаяОбработкаСсылка;
	
	Для Каждого ЭлементОбъектыНазначения Из Параметры.ОбъектыНазначения Цикл
		ОбъектыНазначения.Добавить(ЭлементОбъектыНазначения);
	КонецЦикла;
	
	ИдентификаторКоманды = Параметры.ИдентификаторКоманды;
	ИмяФормыВладельца = Параметры.ИмяФормы;
	
	ИнформацияОВладельце = ДополнительныеОтчетыИОбработкиПовтИсп.ПараметрыФормыНазначаемогоОбъекта(ИмяФормыВладельца);
	
	СсылкаРодителя  = ИнформацияОВладельце.СсылкаРодителя;
	ЭтоФормаОбъекта = ИнформацияОВладельце.ЭтоФормаОбъекта;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы = ДополнительныеОтчетыИОбработкиКлиент.ИмяФормыДлительнойОперации() Тогда
		ЗагрузитьРезультат(ВыбранноеЗначение);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	ПараметрыКоманды = Новый Структура("ДополнительнаяОбработкаСсылка, ОбъектыНазначения, СопровождающийТекст");
	ПараметрыКоманды.ДополнительнаяОбработкаСсылка = ОбъектСсылка;
	ПараметрыКоманды.ОбъектыНазначения = ОбъектыНазначения.ВыгрузитьЗначения();
	ПараметрыКоманды.СопровождающийТекст = НСтр("ru = 'Выполняется сторно движений документов'");
	
	Состояние(ПараметрыКоманды.СопровождающийТекст);
	
	ИдентификаторКоманды="Сторно";
	
	//Если СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая Тогда
	//	Сообщить("Обработка предназначена для использования только в клиент-серверном варианте");
	//	РезультатВыполнения = ВыполнитьКомандуНапрямую(ИдентификаторКоманды, ПараметрыКоманды);
	//	ЗагрузитьРезультат(РезультатВыполнения);
	//Иначе
		//ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКомандуВФоне(ИдентификаторКоманды, ПараметрыКоманды, ЭтаФорма);
		
		МассивСторнируемыхДокументов=Новый Массив;
			
		Для каждого стрДокумент из СторнирумыеДокументы Цикл
			МассивСторнируемыхДокументов.Добавить(стрДокумент.Значение);
		КонецЦикла;
		
		
		
		Если ЕстьДвижения(ОбъектыНазначения[0].Значение) Тогда
			ТекстВопроса = НСтр("ru = 'Существующие проводки и движения регистров будут очищены.
			|Продолжить?'");
			ДопПараметры=Новый Структура;
			ДопПараметры.Вставить("ДокументКорректировки", ОбъектыНазначения[0].Значение);
			ДопПараметры.Вставить("СторнируемыеДокументы", МассивСторнируемыхДокументов);
			ДопПараметры.Вставить("СторнируемыеДокументы", МассивСторнируемыхДокументов);
			//ВызватьИсключение(ОбъектыНазначения[0].Значение);
	        ДопПараметры.Вставить("МассивРегистров",ПолучитьМассивРегистров(ОбъектыНазначения[0].Значение));
			Оповещение = Новый ОписаниеОповещения("ВопросЗаполнитьЗавершение", ЭтотОбъект, ДопПараметры);
			ПоказатьВопрос(Оповещение, ТекстВопроса,РежимДиалогаВопрос.ДаНет);
		Иначе
			//Формирование движений
						
			СформироватьДвиженияСторноСервер(ОбъектыНазначения[0].Значение,МассивСторнируемыхДокументов,ПолучитьМассивРегистров(ОбъектыНазначения[0].Значение));
		КонецЕсли;
	//КонецЕсли;
	
	Если ЭтоФормаОбъекта Тогда
		ЭтаФорма.ВладелецФормы.Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивРегистров(Корректировка)
	Возврат ОбъектыНазначения[0].Значение.ТаблицаРегистров.ВыгрузитьКолонку("Имя");
КонецФункции

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент - Программный интерфейс

&НаКлиенте
Процедура ВыполнитьКоманду(ИмяКоманды, ОбъектыНазначения) Экспорт
	ПараметрыКоманды = Новый Структура("ВнешняяОбработкаСсылка, ОбъектыНазначения", ОбъектСсылка, ОбъектыНазначения);
	РезультатВыполнения = ВыполнитьКомандуНапрямую(ИмяКоманды, ПараметрыКоманды);
	ЗагрузитьРезультат(РезультатВыполнения);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура ЗагрузитьРезультат(РезультатВыполнения)
	Если ТипЗнч(ВладелецФормы) = Тип("УправляемаяФорма") И ЭтоФормаОбъекта Тогда
		ВладелецФормы.Прочитать();
	КонецЕсли;
	ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ВладелецФормы, РезультатВыполнения);
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера, Сервер

&НаСервере
Функция ВыполнитьКомандуНапрямую(ИдентификаторКоманды, ПараметрыКоманды)
	Возврат ДополнительныеОтчетыИОбработки.ВыполнитьКомандуИзФормыВнешнегоОбъекта(ИдентификаторКоманды, ПараметрыКоманды, ЭтаФорма);
КонецФункции

#КонецОбласти

#Область РаботаСоСторно


&НаСервере
Функция ЕстьДвижения(КорРегистров_Объект)
	ДокОбъект=КорРегистров_Объект.ПолучитьОбъект();
	Для каждого Регистр Из ДокОбъект.ТаблицаРегистров Цикл
		ДокОбъект.Движения[Регистр.Имя].Прочитать();
		Если ДокОбъект.Движения[Регистр.Имя].Количество()=0 Тогда
			Продолжить;
		КонецЕсли;
		Возврат Истина;
	КонецЦикла;

	Возврат Ложь;

КонецФункции

&НаКлиенте
Процедура ВопросЗаполнитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		//Формирование движений
		СформироватьДвиженияСторноСервер(ДополнительныеПараметры.ДокументКорректировки,ДополнительныеПараметры.СторнируемыеДокументы,ДополнительныеПараметры.МассивРегистров);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьДвиженияСторноСервер(КорРегистров_Объект, СторнируемыеДокументы,МассивРегистров)
	
	ДокОбъект=КорРегистров_Объект.ПолучитьОбъект();
	Если НЕ ДокОбъект.ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаРегистра Из МассивРегистров Цикл
		ДокОбъект.Движения[СтрокаРегистра].Прочитать();
		Если ДокОбъект.Движения[СтрокаРегистра].Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		ДокОбъект.Движения[СтрокаРегистра].Очистить();
	КонецЦикла;

	ВыполнитьСторнированиеДокументов(СторнируемыеДокументы,,,ДокОбъект);
		МетаданныеДокумента = Документы.КорректировкаРегистров.ПустаяСсылка().Метаданные();
	ЗаполнитьТаблицуРегистров(МетаданныеДокумента, ДокОбъект);
		
КонецПроцедуры

&НаСервере
Процедура ВыполнитьСторнированиеДокументов(СторнируемыеДокументы, СторнироватьРегистры = Истина, СторнироватьПроводки = Истина,ДокументОбъект)
	СтрокаКомментария = "Сторно документов: ";
	Для каждого элМассива Из СторнируемыеДокументы Цикл
		//Документ = СтрокаТЧ.Документ;
		
		
		Если НЕ ЗначениеЗаполнено(элМассива) Тогда
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
				"Колонка",
				"Заполнение",
				НСтр("ru = 'Сторнируемый документ'"),
				элМассива.НомерСтроки,
				НСтр("ru = 'Сторнируемые документы'"));
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ДокументОбъект,
				,
				"Объект");
			Продолжить;
		КонецЕсли;

		МетаданныеДокумент = элМассива.Метаданные();
		Для Каждого МетаданныеРегистр Из МетаданныеДокумент.Движения Цикл
			// если документ "Ручная операция" не может иметь таких движений,
			// то это не сторнируемый регистр
			//Если НЕ ДокументОбъект.Движения.Свойство(МетаданныеРегистр.Имя) Тогда
			//	Продолжить;
			//КонецЕсли;
			Если Метаданные.РегистрыНакопления.Найти(МетаданныеРегистр.Имя) =Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если ДокументОбъект.Движения.Найти(МетаданныеРегистр.Имя)=Неопределено Тогда
				
				продолжить;
			КонецЕсли;
			НаборДвижений = ДокументОбъект.Движения[МетаданныеРегистр.Имя];
			//ЭтоРегистрБухгалтерии = Ложь;
			//Если СторнироватьПроводки И Метаданные.РегистрыБухгалтерии.Содержит(МетаданныеРегистр) Тогда
			//	СторнируемыйНаборЗаписей = РегистрыБухгалтерии[МетаданныеРегистр.Имя].СоздатьНаборЗаписей();
			//	ЭтоРегистрБухгалтерии = Истина;
			//ИначеЕсли СторнироватьРегистры И Метаданные.РегистрыНакопления.Содержит(МетаданныеРегистр) Тогда
			//	СторнируемыйНаборЗаписей = РегистрыНакопления[МетаданныеРегистр.Имя].СоздатьНаборЗаписей();
			//Иначе
			//	Продолжить;
			//КонецЕсли;
			
			СторнируемыйНаборЗаписей = РегистрыНакопления[МетаданныеРегистр.Имя].СоздатьНаборЗаписей();
			
			СторнируемыйНаборЗаписей.Отбор.Регистратор.Значение = элМассива;
			СторнируемыйНаборЗаписей.Прочитать();
			
			
			
			Для Каждого ДвижениеСторнируемое Из СторнируемыйНаборЗаписей Цикл
				ДвижениеСторно = НаборДвижений.Добавить();
				// реквизиты
				ЗаполнитьДвижениеСторно(ДвижениеСторно, ДвижениеСторнируемое, МетаданныеРегистр);
				ДвижениеСторно.Период = ДокументОбъект.Дата;
				
			КонецЦикла;
		КонецЦикла;
	     СтрокаКомментария = СтрокаКомментария +  элМассива + "; ";
	КонецЦикла;
	ДокументОбъект.Комментарий = СтрокаКомментария;
КонецПроцедуры

// Копирует значения движения в строку сторно нового движения
// для измерений и реквизитов. Ресурсы инвертируются
//
&НаСервере
Процедура ЗаполнитьДвижениеСторно(Движение, Строка, МетаданныеОбъект)

	ЗаполнитьЗначенияСвойств(Движение, Строка,,"Период,Регистратор,ВидДвижения");

	// вид движения
	Если МетаданныеОбъект.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
		Движение.ВидДвижения = Строка.ВидДвижения;
	КонецЕсли;

	// ресурсы
	Для каждого МДОбъект Из МетаданныеОбъект.Ресурсы Цикл
		Движение[МДОбъект.Имя] = - Строка[МДОбъект.Имя];
	КонецЦикла;

КонецПроцедуры // ЗаполнитьДвижениеСторно

&НаСервере
Процедура ЗаполнитьТаблицуРегистров(МетаданныеДокумента, КорректировкаОбъект)

	//Если МетаданныеДокумента = Неопределено Тогда
	//	МетаданныеДокумента = Объект.Ссылка.Метаданные();
	//КонецЕсли;


	Для Каждого МетаданныеРегистра Из МетаданныеДокумента.Движения Цикл
		
		Если МетаданныеРегистра.Имя = "Международный"
			 ИЛИ МетаданныеРегистра.Имя = "ОтражениеДокументовВМеждународномУчете" Тогда
			Продолжить;
		КонецЕсли;
		
		Если КорректировкаОбъект.Движения[МетаданныеРегистра.Имя].Количество() Тогда
		    Если КорректировкаОбъект.ТаблицаРегистров.Найти(МетаданныеРегистра.Имя)= Неопределено Тогда
				Регистр     = КорректировкаОбъект.ТаблицаРегистров.Добавить();
				Регистр.Имя = МетаданныеРегистра.Имя;
			КонецЕсли;
			//ПолноеИмя   = МетаданныеРегистра.ПолноеИмя();

			//ПозицияТочки = Найти(ПолноеИмя, ".");
			//ТипРегистра  = Лев(ПолноеИмя, ПозицияТочки - 1);

			//Регистр.ТипРегистра = ТипРегистра;
			//Регистр.Синоним     = МетаданныеРегистра.Синоним;

			//Если Регистр.ТипРегистра = "РегистрНакопления" Тогда
			//	Регистр.РегистрОстатков = (МетаданныеРегистра.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки);
			//КонецЕсли;

		//	Регистр.ЕстьДвижения = (КорректировкаОбъект.Движения[Регистр.Имя].Количество() > 0);
		//
		//Если Регистр.ЕстьДвижения Тогда
		//	
		//	Регистр.Отображение  = Истина;
			
		//ИначеЕсли Регистр.Имя = "Хозрасчетный" Тогда
		//	
		//	Регистр.Отображение  = Истина; // Этот регистр отображается всегда
			
		//Иначе
		//	
		//	// Отображаем те регистры, которые пользователь отметил флагами
		//	Отбор = Новый Структура("Имя", Регистр.Имя);
		//	Если Объект.ТаблицаРегистровНакопления.НайтиСтроки(Отбор).Количество() > 0 Тогда
		//		Регистр.Отображение  = Истина;
		//	ИначеЕсли Объект.ТаблицаРегистровСведений.НайтиСтроки(Отбор).Количество() > 0 Тогда
		//		Регистр.Отображение  = Истина;
		//	КонецЕсли;
			
		КонецЕсли;

	КонецЦикла;

	// Первым показывается регистр бухгалтерии, затем регистры накопления, затем - сведений
	//Регистры.Сортировать("ТипРегистра, Синоним");
	КорректировкаОбъект.Записать();
КонецПроцедуры

#КонецОбласти
