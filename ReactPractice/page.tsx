"use client";

import QuestTracker from "./QuestTracker";
import "./QuestTracker.css"
import { useState, useEffect } from "react";
import {Quest} from "./QuestTracker"

/*
  1. understand better about await and async in typescript
  2. react hook 是什么东西？
  3. next/image
*/
export default function Home() {
  const [quests, setQuests] = useState<Quest[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch ("https://jsonplaceholder.typicode.com/posts");
        if (!response.ok) {
          throw new Error("网络请求失败");
        }
        console.log(response);
        console.log(response.json);
        const fakeResult: Quest[] = [
          {id: 1, title: "complete a mission", completed: false},
          {id: 2, title: "earn 100 points", completed: false},
        ];
        setQuests(fakeResult)
        console.log("quest: " + quests) // X: quests will be empty here
      } catch(error) {
        setError((error as Error).message)
      } finally {
        setLoading(false);
      }
    };
    fetchData();
    console.log("requests sent")
  }, []); 
  
  const toggleQuestCompletion = (id: number) => {
    setQuests((prevQuests: Quest[]) => 
      prevQuests.map((quest) => 
        quest.id === id ? {...quest, completed: !quest.completed} : quest
      )
    );
  }

  useEffect(() => {
    console.log("quests 更新了:", quests); // 这里才是最新的值
  }, [quests]);

  return (
    <div className="container">
      <h1>Welcome to the Quest System</h1>
      {loading ? <p>Loading quests...</p> : <QuestTracker quests={quests} toggleQuestCompletion = {toggleQuestCompletion}/>}
    </div>
  ); 
}