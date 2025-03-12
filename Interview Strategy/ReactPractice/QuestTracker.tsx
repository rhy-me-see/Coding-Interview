"use client";

import "./QuestTracker.css"
import React from "react";

/*
    1. all parameter types in javascript / typescript
    2. setState example
*/

export interface Quest {
    id: number; 
    title: string;
    completed: boolean;
}

const QuestTracker: React.FC<{
    quests: Quest[];
    toggleQuestCompletion: (id: number) => void;
}> = ({ quests, toggleQuestCompletion }) => {
    return (
        <div>
            <h2>Quest Tracker</h2>
            <ul>
                {quests.map((quest) => (
                    <li key={quest.id} className={quest.completed ? "completed": ""}>
                        {quest.title}
                        <button onClick={() => toggleQuestCompletion(quest.id)}>
                            {quest.completed ? "Undo": "Completed"}
                        </button>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default QuestTracker;