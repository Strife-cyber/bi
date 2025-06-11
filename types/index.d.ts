import type { Component } from "vue";

export interface NavItem {
    name: string,
    path: string,
    icon: Component
}


export interface Project {
    id: string;
    name: string;
    description: string;
    createdAt: Date;
    updatedAt: Date;
    analysis: Analysis[];
}

export interface Analysis {
    files: String[],
    result: Record<string, any>,
    createdAt: Date,
    updatedAt: Date
}
